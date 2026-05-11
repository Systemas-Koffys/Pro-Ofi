<script setup>
import { ref, computed } from 'vue'
import { store, uiState, deleteSolicitud, showToast } from '../store/data.js'

const solicitudSeleccionada = ref(null)
const filtroBusqueda = ref('')
const filtroBarrio = ref('')
const filtroAccion = ref('')

const abrirDetalle = (sol) => { solicitudSeleccionada.value = sol }
const imprimir = () => { window.print() }

// Abrir modal en modo edición
const abrirEdicion = (sol) => {
    uiState.editData = { ...sol };   // copia del objeto
    uiState.showModal = true;
}

// Confirmar y eliminar
const confirmarEliminar = async (sol) => {
    const nombre = sol.solicitante_nombre || `#${sol.id_solicitud}`;
    const cod    = sol.comunicacion_interna || `#${sol.id_solicitud}`;
    if (!confirm(`¿Eliminar definitivamente el historial de la solicitud "${cod}"?\nEsta acción borrará el registro permanente.`)) return;
    
    const ok = await deleteSolicitud(sol.id_solicitud);
    if (ok) {
        showToast(`Historial ${cod} eliminado correctamente.`, 'success');
        if (solicitudSeleccionada.value?.id_solicitud == sol.id_solicitud)
            solicitudSeleccionada.value = null;
    } else {
        showToast('No se pudo eliminar. Revisa la conexión.', 'error');
    }
}

const solicitudesFiltradas = computed(() => {
    return store.solicitudes.filter(sol => {
        if (sol.estado_tramite !== 'Terminado') return false
        
        let match = true
        if (filtroBusqueda.value) {
            const term = filtroBusqueda.value.toLowerCase()
            match = sol.solicitante_nombre?.toLowerCase().includes(term) || sol.comunicacion_interna?.toLowerCase().includes(term)
        }
        if (filtroBarrio.value) match = match && sol.id_barrio == filtroBarrio.value
        if (filtroAccion.value) match = match && sol.id_accion == filtroAccion.value
        
        return match
    }).sort((a, b) => new Date(b.fecha_ejecucion) - new Date(a.fecha_ejecucion))
})

const paginaActual = ref(1)
const itemsPorPagina = 20
const totalPaginas = computed(() => Math.ceil(solicitudesFiltradas.value.length / itemsPorPagina) || 1)
const solicitudesPaginadas = computed(() => {
    const start = (paginaActual.value - 1) * itemsPorPagina
    return solicitudesFiltradas.value.slice(start, start + itemsPorPagina)
})

const getBarrio = (id) => store.barrios.find(x => x.id == id)?.nombre || '---'
const getAccion = (id) => store.acciones.find(x => x.id == id)?.nombre || '---'
const getTecnico = (id) => store.tecnicos.find(x => x.id == id)?.nombre || '---'
const getEspecie = (id) => store.especies.find(x => x.id == id)?.nombre || '---'

const formatFecha = (str) => {
    if (!str) return '---'
    const d = new Date(str)
    return d.toLocaleDateString('es-ES', { day:'2-digit', month:'2-digit', year:'numeric' })
}
</script>

<template>
    <div class="historial-view">
        <div id="solicitudes" class="print:hidden">
            <div class="mb-6 flex justify-between items-center">
                <div>
                    <h2 class="text-2xl font-bold text-gray-800 mb-2">
                        Historial de Solicitudes (Terminadas)
                    </h2>
                    <p class="text-gray-600">
                        Consulta el registro histórico de todos los trámites finalizados satisfactoriamente
                    </p>
                </div>
            </div>

            <!-- Barra de Filtros Avanzados -->
            <div class="mb-6 bg-white rounded-lg border border-gray-200 p-4 shadow-sm">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-3">
                    <div class="lg:col-span-2">
                        <label class="block text-xs font-semibold text-gray-500 mb-1 uppercase tracking-wide">Búsqueda general</label>
                        <input type="text" v-model="filtroBusqueda" class="search-input w-full" placeholder="Cod interno, solicitante..." />
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
                </div>

                <div class="mt-3 pt-3 border-t border-gray-100 text-xs text-gray-500">
                    Mostrando <span class="font-bold text-green-600">{{ solicitudesFiltradas.length }}</span> trámites finalizados
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
                                <th>Ejecución</th>
                                <th>Solicitante</th>
                                <th>Barrio</th>
                                <th>Acción Realizada</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-if="solicitudesPaginadas.length === 0">
                                <td colspan="8" class="empty-state text-center p-8">
                                    No hay trámites terminados que coincidan.
                                </td>
                            </tr>
                            <tr v-for="sol in solicitudesPaginadas" :key="sol.id_solicitud">
                                <td class="font-bold text-accent">{{ sol.comunicacion_interna || `#${sol.id_solicitud}` }}</td>
                                <td>{{ formatFecha(sol.fecha_ingreso) }}</td>
                                <td class="text-green-600 font-bold">{{ formatFecha(sol.fecha_ejecucion) }}</td>
                                <td>{{ sol.solicitante_nombre }}</td>
                                <td>{{ getBarrio(sol.id_barrio) }}</td>
                                <td>{{ getAccion(sol.id_accion) }}</td>
                                <td>
                                    <span class="badge badge-completed">
                                        {{ sol.estado_tramite }}
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn-icon btn-ver" @click="abrirDetalle(sol)" title="Ver detalles">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                        </button>
                                        <button class="btn-icon btn-edit" @click="abrirEdicion(sol)" title="Editar registro">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                        </button>
                                        <button v-if="uiState.user?.role === 'ROOT'" class="btn-icon btn-delete" @click="confirmarEliminar(sol)" title="Eliminar definitivamente">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6"/><path d="M10 11v6M14 11v6"/><path d="M9 6V4a1 1 0 011-1h4a1 1 0 011 1v2"/></svg>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Pagination -->
            <div class="flex justify-between items-center bg-card p-4 rounded-2xl border border-border no-print">
                <div class="text-xs font-black text-muted uppercase tracking-widest">
                    Página {{ paginaActual }} de {{ totalPaginas }}
                </div>
                <div class="flex gap-2">
                    <button @click="paginaActual--" :disabled="paginaActual === 1" 
                        class="px-4 py-2 bg-main border border-border rounded-xl font-black text-xs disabled:opacity-50 hover:bg-accent/10 transition-all">
                        Anterior
                    </button>
                    <button @click="paginaActual++" :disabled="paginaActual === totalPaginas" 
                        class="px-4 py-2 bg-main border border-border rounded-xl font-black text-xs disabled:opacity-50 hover:bg-accent/10 transition-all">
                        Siguiente
                    </button>
                </div>
            </div>
        </div>

        <!-- Modal de Detalles (Full) -->
        <div v-if="solicitudSeleccionada" class="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50 print:absolute print:inset-auto print:block print:bg-white print:p-0 print:m-0 print:overflow-visible">
            <div class="bg-gray-50 rounded-2xl shadow-2xl w-full max-w-4xl max-h-[92vh] overflow-y-auto relative print-area print:max-h-none print:overflow-visible print:shadow-none print:rounded-none">

                <!-- ===== CABECERA FORMAL PARA IMPRESIÓN ===== -->
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
                        <h1>REPORTE TÉCNICO DE SOLICITUD FINALIZADA</h1>
                        <div class="print-doc-meta">
                            <span>Cod. Interno: <strong>{{ solicitudSeleccionada.comunicacion_interna || `#${solicitudSeleccionada.id_solicitud}` }}</strong></span>
                            <span>Estado: <strong>{{ solicitudSeleccionada.estado_tramite }}</strong></span>
                            <span>Fecha de emisión: <strong>{{ new Date().toLocaleDateString('es-ES', { day:'2-digit', month:'long', year:'numeric' }) }}</strong></span>
                        </div>
                    </div>
                </div>

                <!-- Header de la tarjeta -->
                <div class="no-print rounded-t-2xl px-6 py-5 flex justify-between items-center" style="background: linear-gradient(135deg, #065f46, #047857);">
                    <div>
                        <p class="text-emerald-100 text-xs font-semibold uppercase tracking-widest mb-1">Trámite Finalizado</p>
                        <h2 class="text-white text-xl font-bold">{{ solicitudSeleccionada.comunicacion_interna || `#${solicitudSeleccionada.id_solicitud}` }}</h2>
                    </div>
                    <div class="flex items-center gap-3">
                        <button @click="imprimir" class="bg-white/15 hover:bg-white/25 text-white px-3 py-2 rounded-lg text-sm font-medium transition-all">Imprimir</button>
                        <button @click="solicitudSeleccionada = null" class="bg-white/10 hover:bg-white/20 text-white w-8 h-8 rounded-full flex items-center justify-center">&times;</button>
                    </div>
                </div>

                <!-- Cuerpo -->
                <div class="p-6 grid grid-cols-1 md:grid-cols-2 gap-5">
                    <div class="bg-white border border-gray-200 rounded-xl p-4">
                        <h4 class="text-xs font-black text-gray-400 uppercase tracking-widest mb-3">Datos Generales</h4>
                        <div class="space-y-2 text-sm">
                            <div class="flex justify-between border-b pb-1"><span>Solicitante:</span><span class="font-bold">{{ solicitudSeleccionada.solicitante_nombre }}</span></div>
                            <div class="flex justify-between border-b pb-1"><span>Barrio:</span><span class="font-bold">{{ getBarrio(solicitudSeleccionada.id_barrio) }}</span></div>
                            <div class="flex justify-between border-b pb-1"><span>Ingreso:</span><span class="font-bold">{{ formatFecha(solicitudSeleccionada.fecha_ingreso) }}</span></div>
                            <div class="flex justify-between"><span>Especie:</span><span class="font-bold">{{ getEspecie(solicitudSeleccionada.id_especie) }}</span></div>
                        </div>
                    </div>
                    <div class="bg-green-50 border border-green-200 rounded-xl p-4">
                        <h4 class="text-xs font-black text-green-700 uppercase tracking-widest mb-3">Ejecución Técnica</h4>
                        <div class="space-y-2 text-sm">
                            <div class="flex justify-between border-b border-green-100 pb-1"><span>Acción Realizada:</span><span class="font-bold">{{ getAccion(solicitudSeleccionada.id_accion) }}</span></div>
                            <div class="flex justify-between border-b border-green-100 pb-1"><span>Fecha Ejecución:</span><span class="font-bold text-green-700">{{ formatFecha(solicitudSeleccionada.fecha_ejecucion) }}</span></div>
                            <div class="flex justify-between"><span>Técnico:</span><span class="font-bold">{{ getTecnico(solicitudSeleccionada.id_tecnico_ejecucion) }}</span></div>
                        </div>
                    </div>
                    <div class="md:col-span-2 bg-gray-100 border border-gray-200 rounded-xl p-4 italic text-sm text-gray-700">
                        <p class="font-black not-italic text-xs text-gray-400 uppercase mb-2">Observaciones Finales de Cierre</p>
                        "{{ solicitudSeleccionada.observaciones_finales || 'Sin observaciones de cierre registradas.' }}"
                    </div>
                </div>

                <div class="no-print px-6 py-4 border-t border-gray-200 flex justify-end">
                    <button @click="solicitudSeleccionada = null" class="px-5 py-2 bg-accent text-white rounded-lg text-sm font-semibold">Cerrar</button>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.badge-completed { @apply bg-green-500 text-white px-3 py-1 rounded-full text-[10px] font-black uppercase; }

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
