<script setup>
import { ref, computed } from 'vue'
import { store, uiState, deleteSolicitud, showToast, registrarImpresion } from '../store/data.js'

const solicitudSeleccionada = ref(null)

const abrirDetalle = (sol) => {
    solicitudSeleccionada.value = sol;
}

// Abrir modal en modo edición
const abrirEdicion = (sol) => {
    uiState.editData = { ...sol };   // copia del objeto
    uiState.showModal = true;
}

// Confirmar y eliminar
const confirmarEliminar = async (sol) => {
    const nombre = sol.solicitante_nombre || `#${sol.id_solicitud}`;
    const cod    = sol.comunicacion_interna || `#${sol.id_solicitud}`;
    if (!confirm(`¿Eliminar la solicitud "${cod}" de ${nombre}?\nEsta acción no se puede deshacer.`)) return;
    const ok = await deleteSolicitud(sol.id_solicitud);
    if (ok) {
        showToast(`Solicitud ${cod} eliminada correctamente.`, 'success');
        if (solicitudSeleccionada.value?.id_solicitud == sol.id_solicitud)
            solicitudSeleccionada.value = null;
    } else {
        showToast('No se pudo eliminar. Revisa la conexión.', 'error');
    }
}

const imprimirReporte = async () => {
    if (solicitudSeleccionada.value) {
        try {
            await registrarImpresion(solicitudSeleccionada.value.id_solicitud, 'Individual')
        } catch (e) {
            console.error("Error al registrar impresión:", e)
        }
    }
    window.print();
}

const filtroBusqueda = ref('')
const filtroBarrio = ref('')
const filtroAccion = ref('')
const filtroFechaDesde = ref('')
const filtroFechaHasta = ref('')

const limpiarFiltros = () => {
    filtroBusqueda.value = ''
    filtroBarrio.value = ''
    filtroAccion.value = ''
    filtroFechaDesde.value = ''
    filtroFechaHasta.value = ''
}

const solicitudesFiltradas = computed(() => {
    return store.solicitudes.filter(sol => {
        // Solo mostrar solicitudes EN ESPERA
        if (sol.estado_tramite !== 'En espera') return false;

        // 1. Búsqueda de texto global
        let coincideBusqueda = true;
        if (filtroBusqueda.value) {
            const term = filtroBusqueda.value.toLowerCase();
            coincideBusqueda =
                (sol.solicitante_nombre && sol.solicitante_nombre.toLowerCase().includes(term)) ||
                (sol.comunicacion_interna && sol.comunicacion_interna.toLowerCase().includes(term)) ||
                (sol.calle && sol.calle.toLowerCase().includes(term)) ||
                (sol.referencia && sol.referencia.toLowerCase().includes(term));
        }

        // 2. Filtro por Barrio
        let coincideBarrio = true;
        if (filtroBarrio.value) {
            coincideBarrio = sol.id_barrio == filtroBarrio.value;
        }

        // 3. Filtro por Acción
        let coincideAccion = true;
        if (filtroAccion.value) {
            coincideAccion =
                sol.id_accion_solicitada == filtroAccion.value ||
                sol.id_accion == filtroAccion.value;
        }

        // 4. Rango de fechas
        let coincideFecha = true;
        const fechaSol = sol.fecha_ingreso ? new Date(sol.fecha_ingreso) : null;
        if (filtroFechaDesde.value && fechaSol) {
            coincideFecha = coincideFecha && fechaSol >= new Date(filtroFechaDesde.value);
        }
        if (filtroFechaHasta.value && fechaSol) {
            const hasta = new Date(filtroFechaHasta.value);
            hasta.setDate(hasta.getDate() + 1);
            coincideFecha = coincideFecha && fechaSol < hasta;
        }

        return coincideBusqueda && coincideBarrio && coincideAccion && coincideFecha;
    }).sort((a, b) => new Date(b.fecha_ingreso) - new Date(a.fecha_ingreso))
})

// --- Lógica de Paginación ---
const paginaActual = ref(1)
const itemsPorPagina = 20

const totalPaginas = computed(() => Math.ceil(solicitudesFiltradas.value.length / itemsPorPagina) || 1)

const solicitudesPaginadas = computed(() => {
    const inicio = (paginaActual.value - 1) * itemsPorPagina
    return solicitudesFiltradas.value.slice(inicio, inicio + itemsPorPagina)
})

const paginasVisibles = computed(() => {
    const total = totalPaginas.value
    const actual = paginaActual.value
    const delta = 2
    let range = []
    for (let i = Math.max(2, actual - delta); i <= Math.min(total - 1, actual + delta); i++) {
        range.push(i)
    }
    if (actual - delta > 2) range.unshift('...')
    if (actual + delta < total - 1) range.push('...')
    range.unshift(1)
    if (total > 1) range.push(total)
    return range.filter(p => p !== '...') // Simplificar para esta vista
})

const getBarrio = (id) => {
    if (!id) return 'N/A';
    const b = store.barrios.find(x => x.id == id)
    return b ? b.nombre : 'N/A'
}

const getAccion = (id) => {
    if (!id) return 'Pendiente'
    const a = store.acciones.find(x => x.id == id)
    return a ? a.nombre : 'Pendiente'
}

const getTecnico = (id) => {
    if (!id) return 'No asignado'
    const t = store.tecnicos.find(x => x.id == id)
    return t ? t.nombre : 'No asignado'
}

const getEspecie = (id) => {
    if (!id) return 'No verificada'
    const e = store.especies.find(x => x.id == id)
    return e ? e.nombre : 'No verificada'
}

const getInstitucion = (id) => {
    if (!id) return 'No corresponde'
    const i = store.instituciones.find(x => x.id == id)
    return i ? i.nombre : 'Desconocida'
}

const formatFecha = (str) => {
    if (!str) return 'No registrada';
    const fecha = new Date(str);
    if (isNaN(fecha.getTime())) return str;
    const dias = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
    const diaSemana = dias[fecha.getUTCDay()];
    const d = String(fecha.getUTCDate()).padStart(2, '0');
    const m = String(fecha.getUTCMonth() + 1).padStart(2, '0');
    const a = String(fecha.getUTCFullYear()).slice(-2);
    return `${diaSemana} ${d}/${m}/${a}`;
}
</script>

<template>
    <div class="solicitudes-view">
        <div id="solicitudes" class="print:hidden">
            <div class="mb-6 flex justify-between items-center">
                <div>
                    <h2 class="text-2xl font-bold text-gray-800 mb-2">
                        Gestión de Solicitudes (Pendientes)
                    </h2>
                    <p class="text-gray-600">
                        Administra los trámites que se encuentran actualmente en espera de atención
                    </p>
                </div>
                <button class="btn-primary" @click="uiState.showModal = true">
                    <svg class="w-5 h-5 inline-block mr-2" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd"
                            d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z"
                            clip-rule="evenodd"></path>
                    </svg>
                    Nueva Solicitud
                </button>
            </div>

            <!-- Barra de Filtros Avanzados -->
            <div class="mb-6 bg-white rounded-lg border border-gray-200 p-4 shadow-sm">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-3">
                    <div class="lg:col-span-2">
                        <label class="block text-xs font-semibold text-gray-500 mb-1 uppercase tracking-wide">Búsqueda general</label>
                        <input type="text" v-model="filtroBusqueda" class="search-input w-full" placeholder="Cod interno, solicitante, referencia..." />
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-gray-500 mb-1 uppercase tracking-wide">Barrio</label>
                        <select v-model="filtroBarrio" class="search-input w-full">
                            <option value="">Todos los barrios</option>
                            <option v-for="b in store.barrios" :key="b.id" :value="b.id">{{ b.nombre }}</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-gray-500 mb-1 uppercase tracking-wide">Tipo de Acción</label>
                        <select v-model="filtroAccion" class="search-input w-full">
                            <option value="">Todas las acciones</option>
                            <option v-for="a in store.acciones" :key="a.id" :value="a.id">{{ a.nombre }}</option>
                        </select>
                    </div>
                    <div class="lg:col-span-2">
                        <label class="block text-xs font-semibold text-gray-500 mb-1 uppercase tracking-wide">Rango de Fechas de Ingreso</label>
                        <div class="flex items-center gap-2">
                            <input type="date" v-model="filtroFechaDesde" class="search-input flex-1" title="Desde" />
                            <span class="text-gray-400 font-medium text-sm">hasta</span>
                            <input type="date" v-model="filtroFechaHasta" class="search-input flex-1" title="Hasta" />
                        </div>
                    </div>
                    <div class="flex items-end">
                        <button @click="limpiarFiltros" class="w-full px-4 py-2 text-sm text-gray-600 border border-gray-300 rounded hover:bg-gray-50 transition-colors">
                            🗑️ Limpiar filtros
                        </button>
                    </div>
                </div>
                <div class="mt-3 pt-3 border-t border-gray-100 text-xs text-gray-500">
                    Mostrando <span class="font-bold text-accent">{{ solicitudesFiltradas.length }}</span> solicitudes en espera
                </div>
            </div>

            <!-- Table -->
            <div class="card mb-6">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Cód. Interno</th>
                                <th>Ingreso</th>
                                <th>Solicitante</th>
                                <th>Barrio</th>
                                <th>Lo Solicitado</th>
                                <th>Lo Determinado</th>
                                <th>Estado</th>
                                <th>Urgencia</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-if="solicitudesPaginadas.length === 0">
                                <td colspan="9" class="empty-state text-center p-8">
                                    No hay solicitudes aún o no coinciden con la búsqueda.
                                </td>
                            </tr>
                            <tr v-for="sol in solicitudesPaginadas" :key="sol.id_solicitud">
                                <td class="font-bold text-accent">{{ sol.comunicacion_interna || `#${sol.id_solicitud}` }}</td>
                                <td>{{ formatFecha(sol.fecha_ingreso) }}</td>
                                <td>{{ sol.solicitante_nombre }}</td>
                                <td>{{ getBarrio(sol.id_barrio) }}</td>
                                <td class="truncate max-w-xs" :title="getAccion(sol.id_accion_solicitada)">{{ getAccion(sol.id_accion_solicitada) }}</td>
                                <td>{{ getAccion(sol.id_accion) }}</td>
                                <td>
                                    <span class="badge" :class="sol.estado_tramite === 'Terminado' ? 'badge-completed' : 'badge-pending'">
                                        {{ sol.estado_tramite }}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge" :class="{
                                        'badge-urgent': sol.nivel_urgencia === 'Alta' || sol.es_emergencia,
                                        'badge-normal': sol.nivel_urgencia === 'Baja' || sol.nivel_urgencia === 'Intermedia'
                                    }">
                                        {{ sol.es_emergencia ? 'EMERGENCIA' : sol.nivel_urgencia }}
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn-icon btn-ver" @click="abrirDetalle(sol)" title="Ver detalles">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                        </button>
                                        <button class="btn-icon btn-edit" @click="abrirEdicion(sol)" title="Editar solicitud">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                        </button>
                                        <button v-if="uiState.user?.role === 'ROOT'" class="btn-icon btn-delete" @click="confirmarEliminar(sol)" title="Eliminar solicitud">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6"/><path d="M10 11v6M14 11v6"/><path d="M9 6V4a1 1 0 011-1h4a1 1 0 011 1v2"/></svg>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Pagination UI -->
            <div class="flex justify-between items-center bg-card p-4 rounded-2xl border border-border no-print">
                <div class="text-xs font-black text-muted uppercase tracking-widest">
                    Página {{ paginaActual }} de {{ totalPaginas }}
                </div>
                <div class="flex gap-2">
                    <button @click="paginaActual--" :disabled="paginaActual === 1" 
                        class="px-4 py-2 bg-main border border-border rounded-xl font-black text-xs uppercase disabled:opacity-50 hover:bg-accent/10 transition-all">
                        Anterior
                    </button>
                    <button v-for="p in paginasVisibles" :key="p" @click="paginaActual = p"
                        :class="['w-10 h-10 rounded-xl font-black text-xs transition-all', 
                                 paginaActual === p ? 'bg-accent text-white shadow-lg' : 'bg-main border border-border text-muted hover:bg-accent/10']">
                        {{ p }}
                    </button>
                    <button @click="paginaActual++" :disabled="paginaActual === totalPaginas" 
                        class="px-4 py-2 bg-main border border-border rounded-xl font-black text-xs uppercase disabled:opacity-50 hover:bg-accent/10 transition-all">
                        Siguiente
                    </button>
                </div>
            </div>
        </div>

        <!-- Modal de Detalles (Reporte) -->
        <div v-if="solicitudSeleccionada" class="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50 print:absolute print:inset-auto print:block print:bg-white print:p-0 print:m-0 print:overflow-visible">
            <div class="bg-gray-50 rounded-2xl shadow-2xl w-full max-w-4xl max-h-[92vh] overflow-y-auto relative print-area print:max-h-none print:overflow-visible print:shadow-none print:rounded-none">

                <!-- ===== CABECERA FORMAL PARA IMPRESIÓN (A4) ===== -->
                <div class="hidden print:block print-header">
                    <div class="print-institution flex items-center gap-6 border-b-2 border-black pb-4 mb-4">
                        <div v-if="uiState.logo_institucional" class="w-32 h-32 flex-shrink-0">
                            <img :src="uiState.logo_institucional" class="w-full h-full object-contain">
                        </div>
                        <div class="print-institution-text flex-1">
                            <p class="print-gov font-black text-lg">Gobierno Autónomo Municipal de Tarija</p>
                            <p class="print-sec font-bold text-sm">Secretaría Municipal de Infraestructura y Servicios</p>
                            <p class="print-unit text-sm font-medium">Unidad de Arboricultura y Espacios Verdes</p>
                        </div>
                    </div>
                    <div class="print-doc-title">
                        <h1>REPORTE TÉCNICO DE SOLICITUD</h1>
                        <div class="print-doc-meta">
                            <span>Cod. Interno: <strong>{{ solicitudSeleccionada.comunicacion_interna || `#${solicitudSeleccionada.id_solicitud}` }}</strong></span>
                            <span>Estado: <strong>{{ solicitudSeleccionada.estado_tramite || 'En espera' }}</strong></span>
                            <span>Urgencia: <strong>{{ solicitudSeleccionada.es_emergencia ? 'EMERGENCIA' : solicitudSeleccionada.nivel_urgencia }}</strong></span>
                            <span>Fecha de emisión: <strong>{{ new Date().toLocaleDateString('es-ES', { day:'2-digit', month:'long', year:'numeric' }) }}</strong></span>
                        </div>
                    </div>
                </div>

                <!-- Header de la tarjeta -->
                <div class="no-print rounded-t-2xl px-6 py-5 flex justify-between items-center" style="background: linear-gradient(135deg, #1a4731, #2d6a4f);">
                    <div>
                        <p class="text-green-200 text-xs font-semibold uppercase tracking-widest mb-1">Trámite de Arboricultura</p>
                        <h2 class="text-white text-xl font-bold">{{ solicitudSeleccionada.comunicacion_interna || `#${solicitudSeleccionada.id_solicitud}` }}</h2>
                        <div class="flex items-center gap-3 mt-2">
                            <span class="text-xs px-2 py-0.5 rounded-full font-semibold"
                                :class="solicitudSeleccionada.estado_tramite === 'Terminado' ? 'bg-emerald-400 text-emerald-900' : 'bg-yellow-300 text-yellow-900'">
                                {{ solicitudSeleccionada.estado_tramite || 'En espera' }}
                            </span>
                            <span class="text-xs px-2 py-0.5 rounded-full font-semibold"
                                :class="solicitudSeleccionada.es_emergencia || solicitudSeleccionada.nivel_urgencia === 'Alta' ? 'bg-red-400 text-red-900' : 'bg-green-200 text-green-900'">
                                {{ solicitudSeleccionada.es_emergencia ? '🚨 EMERGENCIA' : solicitudSeleccionada.nivel_urgencia }}
                            </span>
                        </div>

                        <!-- Fila de insignias de requerimientos -->
                        <div class="flex flex-wrap gap-2 mt-3">
                            <span v-if="solicitudSeleccionada.es_emergencia"
                                class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-red-500 text-white shadow">
                                🚨 Emergencia
                            </span>
                            <span v-if="solicitudSeleccionada.procede"
                                class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-emerald-500 text-white shadow">
                                ✅ Procede trabajo
                            </span>
                            <span v-if="solicitudSeleccionada.requiere_plataforma"
                                class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-yellow-400 text-yellow-900 shadow">
                                🏗️ Plataforma
                            </span>
                            <span v-if="solicitudSeleccionada.requiere_setar"
                                class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-orange-500 text-white shadow">
                                ⚡ Req. SETAR
                            </span>
                            <span v-if="solicitudSeleccionada.requiere_ficha_tecnica"
                                class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-blue-400 text-white shadow">
                                📋 Ficha Técnica
                            </span>
                            <span v-if="solicitudSeleccionada.arbol_seco"
                                class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-amber-600 text-white shadow">
                                🌵 Árbol Seco
                            </span>
                        </div>
                    </div>
                    <div class="flex items-center gap-3">
                        <button @click="imprimirReporte" class="bg-white/15 hover:bg-white/25 text-white px-3 py-2 rounded-lg text-sm font-medium flex items-center gap-2 transition-all">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"></path></svg>
                            Imprimir
                        </button>
                        <button @click="solicitudSeleccionada = null" class="bg-white/10 hover:bg-white/20 text-white w-8 h-8 rounded-full flex items-center justify-center text-xl leading-none transition-all">&times;</button>
                    </div>
                </div>

                <!-- Cuerpo de la tarjeta -->
                <div class="p-6 grid grid-cols-1 md:grid-cols-2 gap-5">

                    <!-- BLOQUE 1: Ingreso -->
                    <div class="bg-amber-50 border border-amber-200 rounded-xl p-4">
                        <h4 class="flex items-center gap-2 text-sm font-bold text-amber-800 uppercase tracking-wide mb-3">
                            <span class="w-6 h-6 bg-amber-500 text-white rounded-full flex items-center justify-center text-xs font-bold">1</span>
                            Datos de Ingreso
                        </h4>
                        <div class="space-y-2 text-sm">
                            <div class="flex justify-between py-1.5 border-b border-amber-100">
                                <span class="text-amber-700 font-medium">Fecha</span>
                                <span class="font-semibold text-gray-800">{{ formatFecha(solicitudSeleccionada.fecha_ingreso) }}</span>
                            </div>
                            <div class="flex justify-between py-1.5 border-b border-amber-100">
                                <span class="text-amber-700 font-medium">Solicitante</span>
                                <span class="font-semibold text-gray-800">{{ solicitudSeleccionada.solicitante_nombre }}</span>
                            </div>
                            <div class="flex justify-between py-1.5">
                                <span class="text-amber-700 font-medium">Teléfono</span>
                                <span class="font-semibold text-gray-800">{{ solicitudSeleccionada.solicitante_telefono || '—' }}</span>
                            </div>
                        </div>
                    </div>

                    <!-- BLOQUE 2: Ubicación -->
                    <div class="bg-teal-50 border border-teal-200 rounded-xl p-4">
                        <h4 class="flex items-center gap-2 text-sm font-bold text-teal-800 uppercase tracking-wide mb-3">
                            <span class="w-6 h-6 bg-teal-500 text-white rounded-full flex items-center justify-center text-xs font-bold">2</span>
                            Ubicación del Árbol
                        </h4>
                        <div class="space-y-2 text-sm">
                            <div class="flex justify-between py-1.5 border-b border-teal-100">
                                <span class="text-teal-700 font-medium">Barrio</span>
                                <span class="font-semibold text-gray-800">{{ getBarrio(solicitudSeleccionada.id_barrio) }}</span>
                            </div>
                            <div class="flex justify-between py-1.5 border-b border-teal-100">
                                <span class="text-teal-700 font-medium">Calle</span>
                                <span class="font-semibold text-gray-800">{{ solicitudSeleccionada.calle }} Nº {{ solicitudSeleccionada.numero_casa || 'S/N' }}</span>
                            </div>
                            <div class="flex justify-between py-1.5 border-b border-teal-100">
                                <span class="text-teal-700 font-medium">Referencia</span>
                                <span class="font-semibold text-gray-800 text-right max-w-[55%]">{{ solicitudSeleccionada.referencia || '—' }}</span>
                            </div>
                            <div v-if="solicitudSeleccionada.id_nombre_institucional" class="flex justify-between py-1.5">
                                <span class="text-teal-700 font-medium">Institución</span>
                                <span class="font-semibold text-gray-800">{{ getInstitucion(solicitudSeleccionada.id_nombre_institucional) }}</span>
                            </div>
                        </div>
                    </div>

                    <!-- BLOQUE 3: Lo Solicitado (ancho completo) -->
                    <div class="md:col-span-2 bg-purple-50 border border-purple-200 rounded-xl p-4">
                        <h4 class="flex items-center gap-2 text-sm font-bold text-purple-800 uppercase tracking-wide mb-3">
                            <span class="w-6 h-6 bg-purple-500 text-white rounded-full flex items-center justify-center text-xs font-bold">3</span>
                            Lo Solicitado por el Vecino
                        </h4>
                        <blockquote class="text-sm text-gray-700 italic bg-white border-l-4 border-purple-400 rounded-r-lg px-4 py-3 mb-3">
                            "{{ solicitudSeleccionada.lo_solicitado || 'Sin descripción.' }}"
                        </blockquote>
                        <p class="text-sm">
                            <span class="text-purple-700 font-medium">Categoría pedida: </span>
                            <span class="font-semibold text-gray-800 bg-purple-100 px-2 py-0.5 rounded">{{ getAccion(solicitudSeleccionada.id_accion_solicitada) }}</span>
                        </p>
                    </div>

                    <!-- BLOQUE 4: Verificación Técnica -->
                    <div class="bg-blue-50 border border-blue-200 rounded-xl p-4">
                        <h4 class="flex items-center gap-2 text-sm font-bold text-blue-800 uppercase tracking-wide mb-3">
                            <span class="w-6 h-6 bg-blue-500 text-white rounded-full flex items-center justify-center text-xs font-bold">4</span>
                            Verificación Técnica
                        </h4>
                        <div class="space-y-2 text-sm">
                            <div class="flex justify-between py-1.5 border-b border-blue-100">
                                <span class="text-blue-700 font-medium">Técnico</span>
                                <span class="font-semibold text-gray-800">{{ getTecnico(solicitudSeleccionada.id_tecnico_verificacion) }}</span>
                            </div>
                            <div class="flex justify-between py-1.5 border-b border-blue-100">
                                <span class="text-blue-700 font-medium">Fecha verificación</span>
                                <span class="font-semibold text-gray-800">{{ formatFecha(solicitudSeleccionada.fecha_verificacion) }}</span>
                            </div>
                            <div class="flex justify-between py-1.5 border-b border-blue-100">
                                <span class="text-blue-700 font-medium">Acción determinada</span>
                                <span class="font-semibold text-gray-800 text-right max-w-[55%]">{{ getAccion(solicitudSeleccionada.id_accion) }}</span>
                            </div>
                            <div class="flex justify-between py-1.5 border-b border-blue-100">
                                <span class="text-blue-700 font-medium">Especie</span>
                                <span class="font-semibold text-gray-800">{{ getEspecie(solicitudSeleccionada.id_especie) }}</span>
                            </div>
                            <div class="flex justify-between py-1.5 border-b border-blue-100">
                                <span class="text-blue-700 font-medium">¿Procede?</span>
                                <span :class="solicitudSeleccionada.procede ? 'text-green-700 font-bold' : 'text-red-700 font-bold'">
                                    {{ solicitudSeleccionada.procede ? '✓ Sí procede' : '✗ No procede' }}
                                </span>
                            </div>
                            <!-- Requerimientos como pills -->
                            <div class="pt-2 flex flex-wrap gap-2">
                                <span v-if="solicitudSeleccionada.arbol_seco" class="bg-amber-100 text-amber-800 px-2 py-1 rounded-full text-xs font-semibold">🌵 Árbol Seco</span>
                                <span v-if="solicitudSeleccionada.requiere_plataforma" class="bg-yellow-100 text-yellow-800 px-2 py-1 rounded-full text-xs font-semibold">🏗️ Plataforma</span>
                                <span v-if="solicitudSeleccionada.requiere_setar" class="bg-orange-100 text-orange-800 px-2 py-1 rounded-full text-xs font-semibold">⚡ SETAR</span>
                                <span v-if="solicitudSeleccionada.requiere_ficha_tecnica" class="bg-blue-100 text-blue-800 px-2 py-1 rounded-full text-xs font-semibold">📋 Ficha Técnica</span>
                                <span v-if="!solicitudSeleccionada.requiere_plataforma && !solicitudSeleccionada.requiere_setar && !solicitudSeleccionada.requiere_ficha_tecnica && !solicitudSeleccionada.arbol_seco" class="text-gray-400 text-xs italic">Sin requerimientos especiales</span>
                            </div>
                        </div>
                        <!-- Observación del técnico -->
                        <div v-if="solicitudSeleccionada.observacion_verificacion" class="mt-3 bg-white rounded-lg border border-blue-100 px-3 py-2 text-sm text-gray-700 italic">
                            "{{ solicitudSeleccionada.observacion_verificacion }}"
                        </div>
                    </div>

                    <!-- BLOQUE 5: Ejecución -->
                    <div class="bg-green-50 border border-green-200 rounded-xl p-4">
                        <h4 class="flex items-center gap-2 text-sm font-bold text-green-800 uppercase tracking-wide mb-3">
                            <span class="w-6 h-6 bg-green-600 text-white rounded-full flex items-center justify-center text-xs font-bold">5</span>
                            Ejecución y Cierre
                        </h4>
                        <div class="space-y-2 text-sm">
                            <div class="flex justify-between py-1.5 border-b border-green-100">
                                <span class="text-green-700 font-medium">Estado</span>
                                <span class="badge" :class="solicitudSeleccionada.estado_tramite === 'Terminado' ? 'badge-completed' : 'badge-pending'">
                                    {{ solicitudSeleccionada.estado_tramite || 'En espera' }}
                                </span>
                            </div>
                            <div class="flex justify-between py-1.5 border-b border-green-100">
                                <span class="text-green-700 font-medium">Técnico Ejecución</span>
                                <span class="font-semibold text-gray-800">{{ getTecnico(solicitudSeleccionada.id_tecnico_ejecucion) }}</span>
                            </div>
                            <div class="flex justify-between py-1.5">
                                <span class="text-green-700 font-medium">Fecha Ejecución</span>
                                <span class="font-semibold text-gray-800">{{ formatFecha(solicitudSeleccionada.fecha_ejecucion) }}</span>
                            </div>
                        </div>
                        <div class="mt-3 bg-white rounded-lg border border-green-100 px-3 py-2 text-sm text-gray-700">
                            {{ solicitudSeleccionada.observaciones_finales || 'Sin reporte de cierre.' }}
                        </div>
                    </div>

                </div>

                <!-- Firmas para Impresión -->
                <div class="hidden print:block print-firmas">
                    <!-- Requerimientos especiales en texto formal -->
                    <div class="print-req-box">
                        <p class="print-req-title">REQUERIMIENTOS ESPECIALES</p>
                        <div class="print-req-list">
                            <span class="print-req-item" :class="solicitudSeleccionada.requiere_plataforma ? 'req-si' : 'req-no'">Grua/Plataforma: {{ solicitudSeleccionada.requiere_plataforma ? 'SI' : 'NO' }}</span>
                            <span class="print-req-item" :class="solicitudSeleccionada.requiere_setar ? 'req-si' : 'req-no'">Corte SETAR: {{ solicitudSeleccionada.requiere_setar ? 'SI' : 'NO' }}</span>
                            <span class="print-req-item" :class="solicitudSeleccionada.requiere_ficha_tecnica ? 'req-si' : 'req-no'">Ficha Tecnica: {{ solicitudSeleccionada.requiere_ficha_tecnica ? 'SI' : 'NO' }}</span>
                            <span class="print-req-item" :class="solicitudSeleccionada.arbol_seco ? 'req-si' : 'req-no'">Arbol Seco: {{ solicitudSeleccionada.arbol_seco ? 'SI' : 'NO' }}</span>
                            <span class="print-req-item" :class="solicitudSeleccionada.procede ? 'req-si' : 'req-no'">Procede: {{ solicitudSeleccionada.procede ? 'SI' : 'NO' }}</span>
                            <span class="print-req-item" :class="solicitudSeleccionada.es_emergencia ? 'req-emergencia' : 'req-no'">Emergencia: {{ solicitudSeleccionada.es_emergencia ? 'SI' : 'NO' }}</span>
                        </div>
                    </div>
                    <!-- Linea de firmas -->
                    <div class="print-firmas-row">
                        <div class="print-firma">
                            <div class="print-firma-linea"></div>
                            <p class="print-firma-nombre">{{ getTecnico(solicitudSeleccionada.id_tecnico_ejecucion) || 'Técnico Asignado' }}</p>
                            <p class="print-firma-cargo">Responsable de Trabajo</p>
                        </div>
                        <div class="print-firma">
                            <div class="print-firma-linea"></div>
                            <p class="print-firma-nombre">Ing. Cimar Farfan</p>
                            <p class="print-firma-cargo">Encargado de Arboricultura</p>
                        </div>
                        <div class="print-firma">
                            <div class="print-firma-linea"></div>
                            <p class="print-firma-nombre">Ing. Raul Arteaga</p>
                            <p class="print-firma-cargo">Jefe de Unidad</p>
                        </div>
                    </div>
                </div>

                <div class="no-print px-6 py-4 border-t border-gray-200 flex justify-end">
                    <button @click="solicitudSeleccionada = null" class="px-5 py-2 rounded-lg text-sm font-semibold text-white transition-all" style="background: #2d6a4f;">Cerrar</button>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
@media print {
    @page {
        size: A4 portrait;
        margin: 1cm 1.2cm;
    }

    /* Ocultar toda la UI, mostrar solo el print-area */
    body > * { display: none !important; }
    .print-area { display: block !important; margin: 0 auto !important; }

    /* Reset del contenedor modal para impresión */
    .print-area {
        background: white !important;
        box-shadow: none !important;
        border-radius: 0 !important;
        max-height: none !important;
        overflow: visible !important;
        font-family: 'Inter', Arial, sans-serif;
        font-size: 9.5pt;
        color: #000;
        width: 100% !important;
        max-width: 19cm !important; /* Centrado dentro de A4 */
    }

    /* Ocultar elementos interactivos */
    .no-print { display: none !important; }

    /* ===== CABECERA INSTITUCIONAL ===== */
    .print-header {
        border-bottom: 2.5pt solid #1a4731;
        margin-bottom: 12pt;
        padding-bottom: 8pt;
    }
    .print-institution {
        display: flex;
        align-items: center;
        gap: 12pt;
    }
    .print-gov {
        font-size: 12pt;
        font-weight: 800;
        text-transform: uppercase;
        letter-spacing: 0.5pt;
        color: #1a4731;
        margin: 0;
    }
    .print-sec {
        font-size: 10pt;
        font-weight: 600;
        color: #2d6a4f;
        margin: 2pt 0 0;
    }
    .print-unit {
        font-size: 9pt;
        color: #444;
        margin: 2pt 0 0;
    }
    .print-doc-title h1 {
        font-size: 13pt;
        font-weight: 900;
        text-align: center;
        text-transform: uppercase;
        letter-spacing: 1.5pt;
        border-top: 1.2pt solid #bbb;
        border-bottom: 1.2pt solid #bbb;
        padding: 6pt 0;
        margin: 10pt 0 6pt;
        color: #1a4731;
    }
    .print-doc-meta {
        display: flex;
        justify-content: space-between;
        font-size: 9pt;
        color: #000;
        padding: 4pt 0;
    }
    .print-doc-meta strong { font-weight: 800; }

    /* ===== CUERPO: GRID 2 COLUMNAS COMPACTO ===== */
    .p-6 {
        padding: 8pt !important;
        gap: 10pt !important;
    }
    /* Bloques de colores se simplifican en print */
    .bg-amber-50, .bg-teal-50, .bg-purple-50, .bg-blue-50, .bg-green-50 {
        background: #fff !important;
        border: 0.8pt solid #ccc !important;
        border-radius: 6pt !important;
        padding: 8pt 10pt !important;
        break-inside: avoid;
    }

    /* Titulos de sección */
    h4 {
        font-size: 9pt !important;
        font-weight: 800 !important;
        text-transform: uppercase;
        letter-spacing: 0.6pt;
        margin-bottom: 6pt !important;
        padding-bottom: 3pt !important;
        border-bottom: 1pt solid #1a4731 !important;
        color: #1a4731 !important;
    }

    /* Numeritos de sección */
    .w-6.h-6 { display: none !important; }

    /* Filas de datos */
    .py-1\.5 { padding: 2.5pt 0 !important; }
    .border-b { border-bottom: 0.5pt solid #eee !important; }
    .text-sm, td, li { font-size: 9pt !important; }

    /* Bloque cita vecino */
    blockquote {
        font-size: 9pt !important;
        padding: 6pt 10pt !important;
        border-left: 3pt solid #1a4731 !important;
        background: #f9f9f9 !important;
        margin: 5pt 0 !important;
    }

    /* ===== REQUERIMIENTOS ===== */
    .print-req-box {
        border: 1.2pt solid #1a4731;
        border-radius: 5pt;
        padding: 6pt 12pt;
        margin: 12pt 0;
    }
    .print-req-title {
        font-size: 9pt;
        font-weight: 900;
        text-transform: uppercase;
        letter-spacing: 0.8pt;
        color: #1a4731;
        margin: 0 0 5pt;
    }
    .print-req-list {
        display: flex;
        flex-wrap: wrap;
        gap: 8pt;
    }
    .print-req-item {
        font-size: 8.5pt;
        font-weight: 700;
        padding: 2pt 10pt;
        border: 0.8pt solid #aaa;
        border-radius: 20pt;
    }
    .req-si  { border-color: #1a4731; color: #1a4731; background: #f0fdf4 !important; }
    .req-no  { color: #bbb; border-style: dashed; }
    .req-emergencia { border-color: #dc2626; color: #dc2626; background: #fef2f2 !important; }

    /* ===== FIRMAS CON MÁS ESPACIO ===== */
    .print-firmas { margin-top: 30pt; }
    .print-firmas-row {
        display: flex;
        justify-content: space-around;
        margin-top: 20pt;
        padding-top: 10pt;
    }
    .print-firma { 
        text-align: center; 
        width: 160pt; 
    }
    .print-firma-linea {
        width: 100%;
        border-bottom: 1pt solid #000;
        margin: 0 auto 8pt;
        height: 60pt; /* Espacio para el sello/firma */
    }
    .print-firma-nombre {
        font-size: 8.5pt;
        font-weight: 800;
        margin: 0;
    }
    .print-firma-cargo {
        font-size: 8pt;
        color: #333;
        margin: 2pt 0 0;
        text-transform: uppercase;
    }
}

/* ===== BOTONES ACCION TABLA ===== */
.btn-ver, .btn-edit, .btn-delete {
    display: inline-flex; align-items: center; justify-content: center;
    width: 30px; height: 30px; border-radius: 7px;
    border: none; cursor: pointer; transition: all 0.18s ease; padding: 0;
}
.btn-ver svg, .btn-edit svg, .btn-delete svg { width: 15px; height: 15px; }
.btn-ver    { background: #d8f3dc; color: #1a4731; }
.btn-ver:hover    { background: #74c69d; color: #0f2e1e; transform: translateY(-1px); }
.btn-edit   { background: #fef3c7; color: #92400e; }
.btn-edit:hover   { background: #fde68a; color: #78350f; transform: translateY(-1px); }
.btn-delete { background: #fee2e2; color: #991b1b; }
.btn-delete:hover { background: #fca5a5; color: #7f1d1d; transform: translateY(-1px); }
</style>
