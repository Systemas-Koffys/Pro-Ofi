<template>
<div>
    <div id="solicitudes" class="print:hidden">
        <div class="mb-6 flex justify-between items-center">
            <div>
                <h2 class="text-2xl font-bold text-gray-800 mb-2">
                    Solicitudes de Poda
                </h2>
                <p class="text-gray-600">
                    Administra todas las solicitudes de podas y derribos del sistema
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

        <!-- Search and Filters -->
        <div class="mb-6 grid grid-cols-1 md:grid-cols-3 gap-4">
            <input type="text" v-model="filtroBusqueda" class="search-input" placeholder="Buscar por cod, solicitante o calle..." />
            
            <select v-model="filtroBarrio" class="search-input">
                <option value="">Filtrar por Barrio</option>
                <option v-for="b in store.barrios" :key="b.id" :value="b.id">{{ b.nombre }}</option>
            </select>
            
            <input type="date" v-model="filtroFecha" class="search-input" />
        </div>

        <!-- Table -->
        <div class="card">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID/Cod</th>
                            <th>Ingreso</th>
                            <th>Solicitante</th>
                            <th>Ubicación (Barrio)</th>
                            <th>Lo Solicitado</th>
                            <th>Acción</th>
                            <th>Etapa</th>
                            <th>Urgencia</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-if="solicitudesFiltradas.length === 0">
                            <td colspan="9" class="empty-state text-center p-8">
                                <svg xmlns="http://www.w3.org/2000/svg" class="mx-auto h-12 w-12 text-gray-400 mb-3" viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z">
                                    </path>
                                </svg>
                                No hay solicitudes aún o no coinciden con la búsqueda.
                            </td>
                        </tr>
                        <tr v-for="sol in solicitudesFiltradas" :key="sol.id_solicitud">
                            <td class="font-bold text-blue-600">{{ sol.comunicacion_interna || `#${sol.id_solicitud}` }}</td>
                            <td>{{ formatFecha(sol.fecha_ingreso) }}</td>
                            <td>{{ sol.solicitante_nombre }}</td>
                            <td>{{ getBarrio(sol.id_barrio) }}</td>
                            <td class="truncate max-w-xs" :title="sol.lo_solicitado">{{ sol.lo_solicitado }}</td>
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
                                    <button class="btn-icon" @click="abrirDetalle(sol)" title="Ver detalles completos">👁️</button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal de Detalles (Reporte) -->
    <div v-if="solicitudSeleccionada" class="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50 print:absolute print:inset-auto print:block print:bg-white print:p-0 print:m-0 print:overflow-visible">
        <div class="bg-white rounded-lg shadow-xl w-full max-w-4xl max-h-[90vh] overflow-y-auto relative print-area print:max-h-none print:overflow-visible print:shadow-none print:rounded-none">
            
            <!-- Cabecera exclusiva para Impresión -->
            <div class="hidden print:block text-center mb-8 border-b-2 border-gray-800 pb-4">
                <h1 class="text-2xl font-bold text-gray-900 uppercase">Gobierno Autónomo Municipal de Tarija</h1>
                <h2 class="text-xl font-semibold text-gray-700 mt-1">Secretaría de Obras Públicas</h2>
                <h3 class="text-lg font-medium text-gray-600 mt-2">Reporte Técnico: Área de Arboricultura</h3>
                <p class="text-sm mt-4 font-bold">Solicitud N°: {{ solicitudSeleccionada.comunicacion_interna || `#${solicitudSeleccionada.id_solicitud}` }}</p>
                <p class="text-sm text-gray-500">Fecha de Emisión: {{ new Date().toLocaleDateString('es-ES') }}</p>
            </div>

            <div class="sticky top-0 bg-white px-6 py-4 border-b flex justify-between items-center z-10 no-print">
                <h3 class="text-xl font-bold text-gray-800">
                    Detalle de Solicitud: <span class="text-blue-600">{{ solicitudSeleccionada.comunicacion_interna || `#${solicitudSeleccionada.id_solicitud}` }}</span>
                </h3>
                <div class="flex items-center space-x-4 no-print">
                    <button @click="imprimirReporte" class="bg-blue-600 text-white px-3 py-1.5 rounded hover:bg-blue-700 text-sm font-medium flex items-center">
                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"></path></svg>
                        Imprimir
                    </button>
                    <button @click="solicitudSeleccionada = null" class="text-gray-500 hover:text-red-500 font-bold text-2xl leading-none">&times;</button>
                </div>
            </div>

            <div class="p-6 grid grid-cols-1 md:grid-cols-2 gap-8">
                
                <!-- Columna Izquierda: Ingreso y Ubicación -->
                <div>
                    <h4 class="font-semibold text-lg text-gray-700 border-b pb-2 mb-4">1. Datos de Ingreso</h4>
                    <ul class="space-y-3 text-sm">
                        <li><span class="font-semibold text-gray-600">Fecha Ingreso:</span> {{ formatFecha(solicitudSeleccionada.fecha_ingreso) }}</li>
                        <li><span class="font-semibold text-gray-600">Solicitante:</span> {{ solicitudSeleccionada.solicitante_nombre }}</li>
                        <li><span class="font-semibold text-gray-600">Teléfono:</span> {{ solicitudSeleccionada.solicitante_telefono || 'No registrado' }}</li>
                        <li><span class="font-semibold text-gray-600">Urgencia:</span> 
                            <span class="ml-2 px-2 py-0.5 rounded text-xs font-bold" 
                                :class="solicitudSeleccionada.es_emergencia || solicitudSeleccionada.nivel_urgencia === 'Alta' ? 'bg-red-100 text-red-800' : 'bg-blue-100 text-blue-800'">
                                {{ solicitudSeleccionada.es_emergencia ? 'EMERGENCIA' : solicitudSeleccionada.nivel_urgencia }}
                            </span>
                        </li>
                    </ul>

                    <h4 class="font-semibold text-lg text-gray-700 border-b pb-2 mb-4 mt-8">2. Ubicación Exacta</h4>
                    <ul class="space-y-3 text-sm">
                        <li><span class="font-semibold text-gray-600">Barrio:</span> {{ getBarrio(solicitudSeleccionada.id_barrio) }}</li>
                        <li><span class="font-semibold text-gray-600">Calle/Av:</span> {{ solicitudSeleccionada.calle }} (Nº {{ solicitudSeleccionada.numero_casa || 'S/N' }})</li>
                        <li><span class="font-semibold text-gray-600">Referencia:</span> {{ solicitudSeleccionada.referencia }}</li>
                        <li v-if="solicitudSeleccionada.id_nombre_institucional">
                            <span class="font-semibold text-gray-600">Institución:</span> {{ getInstitucion(solicitudSeleccionada.id_nombre_institucional) }}
                        </li>
                    </ul>

                    <h4 class="font-semibold text-lg text-gray-700 border-b pb-2 mb-4 mt-8">3. Lo Solicitado (Vecino/Institución)</h4>
                    <p class="text-sm text-gray-800 bg-gray-50 p-3 rounded border italic">
                        "{{ solicitudSeleccionada.lo_solicitado }}"
                    </p>
                    <p class="text-sm mt-2"><span class="font-semibold text-gray-600">Acción pedida:</span> {{ getAccion(solicitudSeleccionada.id_accion_solicitada) }}</p>
                </div>

                <!-- Columna Derecha: Verificación y Ejecución -->
                <div>
                    <h4 class="font-semibold text-lg text-gray-700 border-b pb-2 mb-4">4. Verificación Técnica</h4>
                    <ul class="space-y-3 text-sm">
                        <li><span class="font-semibold text-gray-600">Técnico Verificador:</span> {{ getTecnico(solicitudSeleccionada.id_tecnico_verificacion) }}</li>
                        <li><span class="font-semibold text-gray-600">Fecha Verificación:</span> {{ formatFecha(solicitudSeleccionada.fecha_verificacion) }}</li>
                        <li><span class="font-semibold text-gray-600">Acción Determinada:</span> {{ getAccion(solicitudSeleccionada.id_accion) }}</li>
                        <li><span class="font-semibold text-gray-600">Especie de Árbol:</span> {{ getEspecie(solicitudSeleccionada.id_especie) }}</li>
                        <li><span class="font-semibold text-gray-600">¿Árbol Seco?:</span> {{ solicitudSeleccionada.arbol_seco ? 'Sí' : 'No' }}</li>
                        <li><span class="font-semibold text-gray-600">¿Procede?:</span> {{ solicitudSeleccionada.procede ? 'Sí, procede' : 'Rechazado' }}</li>
                        
                        <li class="mt-4 border-t pt-4">
                            <span class="font-semibold text-gray-600">Requerimientos:</span>
                            <div class="flex gap-2 mt-2">
                                <span v-if="solicitudSeleccionada.requiere_plataforma" class="bg-yellow-100 text-yellow-800 px-2 py-1 rounded text-xs">Grúa/Plataforma</span>
                                <span v-if="solicitudSeleccionada.requiere_setar" class="bg-orange-100 text-orange-800 px-2 py-1 rounded text-xs">Corte SETAR</span>
                                <span v-if="solicitudSeleccionada.requiere_ficha_tecnica" class="bg-blue-100 text-blue-800 px-2 py-1 rounded text-xs">Ficha Técnica</span>
                            </div>
                        </li>
                        <li>
                            <span class="font-semibold text-gray-600 block mt-2">Observaciones del Técnico:</span>
                            <p class="text-sm text-gray-800 bg-gray-50 p-2 rounded border mt-1">
                                {{ solicitudSeleccionada.observacion_verificacion || 'Sin observaciones.' }}
                            </p>
                        </li>
                    </ul>

                    <h4 class="font-semibold text-lg text-gray-700 border-b pb-2 mb-4 mt-8">5. Ejecución (Cuadrilla)</h4>
                    <ul class="space-y-3 text-sm">
                        <li><span class="font-semibold text-gray-600">Estado Actual:</span> 
                            <span class="ml-2 badge" :class="solicitudSeleccionada.estado_tramite === 'Terminado' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'">
                                {{ solicitudSeleccionada.estado_tramite }}
                            </span>
                        </li>
                        <li><span class="font-semibold text-gray-600">Jefe de Cuadrilla:</span> {{ getTecnico(solicitudSeleccionada.id_tecnico_ejecucion) }}</li>
                        <li><span class="font-semibold text-gray-600">Fecha de Ejecución:</span> {{ formatFecha(solicitudSeleccionada.fecha_ejecucion) || 'Pendiente' }}</li>
                        <li>
                            <span class="font-semibold text-gray-600 block mt-2">Observaciones Finales:</span>
                            <p class="text-sm text-gray-800 bg-gray-50 p-2 rounded border mt-1 min-h-[60px]">
                                {{ solicitudSeleccionada.observaciones_finales || 'Sin reporte de ejecución.' }}
                            </p>
                        </li>
                    </ul>
                </div>

            </div>
            
            <!-- Firmas exclusivas para Impresión -->
            <div class="hidden print:flex justify-around mt-16 pt-16 border-t border-gray-300">
                <div class="text-center px-4">
                    <div class="w-40 border-b border-gray-800 mb-2 mx-auto"></div>
                    <p class="font-bold text-gray-800">Vo.Bo. Tec. Sistemas</p>
                    <p class="text-xs text-gray-600">Kevin Flores Vallejos</p>
                </div>
                <div class="text-center px-4">
                    <div class="w-40 border-b border-gray-800 mb-2 mx-auto"></div>
                    <p class="font-bold text-gray-800">Encargado Arboricultura</p>
                    <p class="text-xs text-gray-600">Ing. Cimar Farfán</p>
                </div>
                <div class="text-center px-4">
                    <div class="w-40 border-b border-gray-800 mb-2 mx-auto"></div>
                    <p class="font-bold text-gray-800">Jefe de Unidad</p>
                    <p class="text-xs text-gray-600">Ing. Raul Arteaga</p>
                </div>
            </div>

            <div class="sticky bottom-0 bg-gray-50 px-6 py-4 border-t text-right no-print">
                <button @click="solicitudSeleccionada = null" class="px-4 py-2 bg-gray-600 text-white rounded hover:bg-gray-700 font-medium">Cerrar Reporte</button>
            </div>
        </div>
    </div>

</div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { store, uiState } from '../store/data.js'

const solicitudSeleccionada = ref(null)

const abrirDetalle = (sol) => {
    solicitudSeleccionada.value = sol;
}

const imprimirReporte = () => {
    window.print();
}

const filtroBusqueda = ref('')
const filtroBarrio = ref('')
const filtroFecha = ref('')

const solicitudesFiltradas = computed(() => {
    return store.solicitudes.filter(sol => {
        let coincideBusqueda = true;
        if (filtroBusqueda.value) {
            const term = filtroBusqueda.value.toLowerCase();
            coincideBusqueda = 
                (sol.solicitante_nombre && sol.solicitante_nombre.toLowerCase().includes(term)) ||
                (sol.comunicacion_interna && sol.comunicacion_interna.toLowerCase().includes(term)) ||
                (sol.calle && sol.calle.toLowerCase().includes(term));
        }

        let coincideBarrio = true;
        if (filtroBarrio.value) {
            coincideBarrio = sol.id_barrio === filtroBarrio.value;
        }

        let coincideFecha = true;
        if (filtroFecha.value) {
            coincideFecha = sol.fecha_ingreso === filtroFecha.value;
        }

        return coincideBusqueda && coincideBarrio && coincideFecha;
    })
})

const getBarrio = (id) => {
    const b = store.barrios.find(x => x.id === id)
    return b ? b.nombre : 'N/A'
}

const getAccion = (id) => {
    if(!id) return 'Pendiente'
    const a = store.acciones.find(x => x.id === id)
    return a ? a.nombre : 'Pendiente'
}

const getTecnico = (id) => {
    if(!id) return 'No asignado'
    const t = store.tecnicos.find(x => x.id === id)
    return t ? t.nombre : 'No asignado'
}

const getEspecie = (id) => {
    if(!id) return 'No verificada'
    const e = store.especies.find(x => x.id === id)
    return e ? e.nombre : 'No verificada'
}

const getInstitucion = (id) => {
    if(!id) return 'No corresponde'
    const i = store.instituciones.find(x => x.id === id)
    return i ? i.nombre : 'Desconocida'
}

const formatFecha = (str) => {
    if(!str) return 'No registrada';
    const [y, m, d] = str.split('-');
    return `${d}/${m}/${y}`;
}
</script>