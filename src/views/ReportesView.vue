<script setup>
import { ref, computed } from 'vue'
import { store, registrarImpresion, showToast } from '../store/data.js'

const activeTab = ref('generador')

// Filtros para el generador
const filtroBarrio = ref('')
const filtroTecnico = ref('')
const filtroSetar = ref('')
const filtroPlataforma = ref('')
const filtroEstado = ref('En espera') 
const filtroUrgencia = ref('')
const filtroAccion = ref('')
const filtroEspecie = ref('')

const solicitudesFiltradas = computed(() => {
    return store.solicitudes.filter(sol => {
        let match = true
        if (filtroBarrio.value && sol.id_barrio != filtroBarrio.value) match = false
        if (filtroTecnico.value && sol.id_tecnico_ejecucion != filtroTecnico.value) match = false
        if (filtroUrgencia.value && sol.nivel_urgencia != filtroUrgencia.value) match = false
        if (filtroAccion.value && sol.id_accion != filtroAccion.value) match = false
        if (filtroEspecie.value && sol.id_especie != filtroEspecie.value) match = false
        
        if (filtroSetar.value !== '') {
            const reqSetar = sol.requiere_setar ? '1' : '0'
            if (reqSetar !== filtroSetar.value) match = false
        }
        if (filtroPlataforma.value !== '') {
            const reqPlat = sol.requiere_plataforma ? '1' : '0'
            if (reqPlat !== filtroPlataforma.value) match = false
        }
        if (filtroEstado.value && sol.estado_tramite !== filtroEstado.value) match = false
        return match
    })
})

const getBarrio = (id) => {
    const b = store.barrios.find(x => x.id == id)
    return b ? b.nombre : 'N/A'
}

const getAccion = (id) => {
    const a = store.acciones.find(x => x.id == id)
    return a ? a.nombre : 'N/A'
}

const getEspecie = (id) => {
    const e = store.especies.find(x => x.id == id)
    return e ? e.nombre : 'N/A'
}

const imprimirGrupal = async () => {
    if (solicitudesFiltradas.value.length === 0) {
        showToast('No hay solicitudes para imprimir', 'error')
        return
    }
    
    // Registrar en el historial
    const detalles = `Barrio: ${getBarrio(filtroBarrio.value)}, Total: ${solicitudesFiltradas.value.length}`
    await registrarImpresion(null, 'Grupal', detalles)
    
    window.print()
}

const formatFecha = (str) => {
    if (!str) return '—'
    const f = new Date(str)
    return f.toLocaleDateString('es-ES')
}
</script>

<template>
    <div class="reportes-container">
        <!-- Pestañas -->
        <div class="flex gap-4 mb-6 no-print">
            <button @click="activeTab = 'generador'" 
                :class="activeTab === 'generador' ? 'bg-emerald-600 text-white' : 'bg-white text-gray-600 border border-gray-200'"
                class="px-6 py-2 rounded-xl font-bold transition-all shadow-sm">
                Generador de Hojas de Ruta
            </button>
            <button @click="activeTab = 'historial'" 
                :class="activeTab === 'historial' ? 'bg-emerald-600 text-white' : 'bg-white text-gray-600 border border-gray-200'"
                class="px-6 py-2 rounded-xl font-bold transition-all shadow-sm">
                Historial de Impresiones
            </button>
        </div>

        <!-- VISTA GENERADOR -->
        <div v-if="activeTab === 'generador'" class="no-print animate-fade-in">
            <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6 mb-6">
                <h3 class="text-lg font-bold text-gray-800 mb-4 flex items-center gap-2">
                    <svg class="w-5 h-5 text-emerald-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z"></path></svg>
                    Filtros de Reporte Grupal
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-4">
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Barrio</label>
                        <select v-model="filtroBarrio" class="w-full px-3 py-2 rounded-lg border border-gray-200 focus:ring-2 focus:ring-emerald-500 outline-none text-sm">
                            <option value="">Todos los barrios</option>
                            <option v-for="b in store.barrios" :key="b.id" :value="b.id">{{ b.nombre }}</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Acción Técnica</label>
                        <select v-model="filtroAccion" class="w-full px-3 py-2 rounded-lg border border-gray-200 focus:ring-2 focus:ring-emerald-500 outline-none text-sm">
                            <option value="">Cualquier acción</option>
                            <option v-for="a in store.acciones" :key="a.id" :value="a.id">{{ a.nombre }}</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Especie</label>
                        <select v-model="filtroEspecie" class="w-full px-3 py-2 rounded-lg border border-gray-200 focus:ring-2 focus:ring-emerald-500 outline-none text-sm">
                            <option value="">Cualquier especie</option>
                            <option v-for="e in store.especies" :key="e.id" :value="e.id">{{ e.nombre }}</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Urgencia</label>
                        <select v-model="filtroUrgencia" class="w-full px-3 py-2 rounded-lg border border-gray-200 focus:ring-2 focus:ring-emerald-500 outline-none text-sm">
                            <option value="">Todas</option>
                            <option value="Baja">Baja</option>
                            <option value="Intermedia">Intermedia</option>
                            <option value="Alta">Alta</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Requiere SETAR</label>
                        <select v-model="filtroSetar" class="w-full px-3 py-2 rounded-lg border border-gray-200 focus:ring-2 focus:ring-emerald-500 outline-none text-sm">
                            <option value="">Ambos</option>
                            <option value="1">Sí</option>
                            <option value="0">No</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Requiere Grúa</label>
                        <select v-model="filtroPlataforma" class="w-full px-3 py-2 rounded-lg border border-gray-200 focus:ring-2 focus:ring-emerald-500 outline-none text-sm">
                            <option value="">Ambos</option>
                            <option value="1">Sí</option>
                            <option value="0">No</option>
                        </select>
                    </div>
                    <div class="flex items-end">
                        <button @click="imprimirGrupal" class="w-full bg-emerald-600 hover:bg-emerald-700 text-white px-4 py-2 rounded-lg font-bold flex items-center justify-center gap-2 transition-all shadow-lg shadow-emerald-200">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"></path></svg>
                            Generar Hoja de Ruta
                        </button>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden">
                <div class="px-6 py-4 bg-gray-50 border-b border-gray-100 flex justify-between items-center">
                    <span class="text-sm font-bold text-gray-600">Previsualización ({{ solicitudesFiltradas.length }} solicitudes)</span>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full text-left">
                        <thead>
                            <tr class="text-[11px] font-black uppercase text-gray-400 border-b border-gray-100">
                                <th class="px-6 py-3">Cod</th>
                                <th class="px-6 py-3">Dirección / Barrio</th>
                                <th class="px-6 py-3">Acción</th>
                                <th class="px-6 py-3">Req.</th>
                                <th class="px-6 py-3">Solicitante</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="sol in solicitudesFiltradas" :key="sol.id_solicitud" class="border-b border-gray-50 hover:bg-emerald-50/30 transition-colors">
                                <td class="px-6 py-4 font-bold text-emerald-700 text-sm">{{ sol.comunicacion_interna }}</td>
                                <td class="px-6 py-4">
                                    <p class="text-sm font-bold text-gray-800">{{ sol.calle }} {{ sol.numero_casa }}</p>
                                    <p class="text-[10px] text-gray-500 uppercase font-bold">{{ getBarrio(sol.id_barrio) }}</p>
                                </td>
                                <td class="px-6 py-4 text-xs font-medium text-gray-600">{{ getAccion(sol.id_accion) }}</td>
                                <td class="px-6 py-4">
                                    <div class="flex gap-1">
                                        <span v-if="sol.requiere_setar" class="w-5 h-5 bg-orange-100 text-orange-600 rounded flex items-center justify-center text-[10px] font-bold" title="SETAR">⚡</span>
                                        <span v-if="sol.requiere_plataforma" class="w-5 h-5 bg-blue-100 text-blue-600 rounded flex items-center justify-center text-[10px] font-bold" title="Grúa">🏗️</span>
                                    </div>
                                </td>
                                <td class="px-6 py-4 text-xs text-gray-500">{{ sol.solicitante_nombre }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- VISTA HISTORIAL -->
        <div v-if="activeTab === 'historial'" class="animate-fade-in">
            <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden">
                <table class="w-full text-left">
                    <thead class="bg-gray-50">
                        <tr class="text-[11px] font-black uppercase text-gray-400 border-b border-gray-100">
                            <th class="px-6 py-4">Fecha/Hora</th>
                            <th class="px-6 py-4">Tipo</th>
                            <th class="px-6 py-4">Usuario</th>
                            <th class="px-6 py-4">Referencia / Detalles</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="imp in store.impresiones" :key="imp.id" class="border-b border-gray-50">
                            <td class="px-6 py-4 text-sm text-gray-600">{{ new Date(imp.fecha_impresion).toLocaleString() }}</td>
                            <td class="px-6 py-4">
                                <span class="px-2 py-0.5 rounded text-[10px] font-bold uppercase"
                                    :class="imp.tipo_reporte === 'Individual' ? 'bg-blue-100 text-blue-600' : 'bg-purple-100 text-purple-600'">
                                    {{ imp.tipo_reporte }}
                                </span>
                            </td>
                            <td class="px-6 py-4 text-sm font-bold text-gray-700">{{ imp.usuario }}</td>
                            <td class="px-6 py-4">
                                <p class="text-sm font-bold text-gray-800">{{ imp.comunicacion_interna || 'Reporte Grupal' }}</p>
                                <p class="text-xs text-gray-500">{{ imp.detalles }}</p>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ÁREA DE IMPRESIÓN GRUPAL (ESTILO INSTITUCIONAL) -->
        <div class="hidden print:block bulk-print-layout">
            <div class="print-header-formal mb-6 border-b-4 border-[#1a4731] pb-4 flex justify-between items-end">
                <div class="flex gap-4 items-center">
                    <div class="text-left">
                        <p class="text-[14px] font-black uppercase text-[#1a4731] leading-tight">Gobierno Autónomo Municipal de Tarija</p>
                        <p class="text-[11px] font-bold text-[#2d6a4f] uppercase tracking-wide">Secretaría de Infraestructura y Servicios</p>
                        <p class="text-[10px] text-gray-500 font-bold uppercase tracking-widest">Unidad de Arboricultura</p>
                    </div>
                </div>
                <div class="text-right">
                    <h1 class="text-xl font-black text-[#1a4731] uppercase tracking-tighter">Hoja de Ruta de Campo</h1>
                    <p class="text-xs font-bold text-gray-600">Fecha de Emisión: {{ new Date().toLocaleDateString('es-ES', { day:'2-digit', month:'long', year:'numeric' }) }}</p>
                </div>
            </div>

            <div class="flex justify-between items-center mb-4 bg-gray-50 p-3 border border-gray-200 rounded-lg">
                <div class="flex gap-6 text-[10px] font-bold uppercase text-gray-700">
                    <span>Filtro Barrio: <span class="text-emerald-700">{{ getBarrio(filtroBarrio) || 'Todos' }}</span></span>
                    <span>Acción: <span class="text-emerald-700">{{ getAccion(filtroAccion) || 'Todas' }}</span></span>
                </div>
                <div class="text-[10px] font-black text-emerald-900 uppercase">
                    Total Solicitudes: {{ solicitudesFiltradas.length }}
                </div>
            </div>

            <table class="w-full border-collapse border-2 border-black">
                <thead>
                    <tr class="bg-gray-100 text-[10px] uppercase font-black text-center">
                        <th class="border-2 border-black p-2 w-16">Cod.</th>
                        <th class="border-2 border-black p-2 w-40 text-left">Solicitante / Tel.</th>
                        <th class="border-2 border-black p-2 text-left">Dirección / Referencia del Trabajo</th>
                        <th class="border-2 border-black p-2 w-32 text-left">Acción a Realizar</th>
                        <th class="border-2 border-black p-2 w-20">Urgencia</th>
                        <th class="border-2 border-black p-2 w-12">Setar</th>
                        <th class="border-2 border-black p-2 w-12">Grúa</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="sol in solicitudesFiltradas" :key="sol.id_solicitud" class="text-[11px]">
                        <td class="border-2 border-black p-2 text-center font-bold text-emerald-800">{{ sol.comunicacion_interna || `#${sol.id_solicitud}` }}</td>
                        <td class="border-2 border-black p-2">
                            <p class="font-bold">{{ sol.solicitante_nombre }}</p>
                            <p class="text-[9px] text-blue-800">{{ sol.solicitante_telefono || 'S/T' }}</p>
                        </td>
                        <td class="border-2 border-black p-2">
                            <p class="font-black uppercase text-[#1a4731]">{{ sol.calle }} {{ sol.numero_casa }}</p>
                            <p class="text-[10px] italic text-gray-700 leading-tight">{{ sol.referencia }}</p>
                            <p class="text-[9px] font-black text-emerald-900 mt-1">Barrio: {{ getBarrio(sol.id_barrio) }}</p>
                        </td>
                        <td class="border-2 border-black p-2">
                            <p class="font-bold uppercase text-gray-800">{{ getAccion(sol.id_accion) }}</p>
                        </td>
                        <td class="border-2 border-black p-2 text-center font-bold" :class="sol.nivel_urgencia === 'Alta' ? 'text-red-700' : ''">
                            {{ sol.nivel_urgencia }}
                        </td>
                        <td class="border-2 border-black p-2 text-center font-bold">{{ sol.requiere_setar ? 'SÍ' : 'NO' }}</td>
                        <td class="border-2 border-black p-2 text-center font-bold">{{ sol.requiere_plataforma ? 'SÍ' : 'NO' }}</td>
                    </tr>
                </tbody>
            </table>

            <div class="mt-16 grid grid-cols-3 gap-12 text-center">
                <div class="border-t-2 border-black pt-2">
                    <div class="h-24"></div>
                    <p class="text-[11px] font-black uppercase">Técnico Responsable</p>
                    <p class="text-[9px] text-gray-500 uppercase">Nombre y Firma</p>
                </div>
                <div class="border-t-2 border-black pt-2">
                    <div class="h-24"></div>
                    <p class="text-[11px] font-black uppercase">Vo.Bo. Arboricultura</p>
                    <p class="text-[9px] text-gray-500 uppercase">Ing. Cimar Farfan</p>
                </div>
                <div class="border-t-2 border-black pt-2">
                    <div class="h-24"></div>
                    <p class="text-[11px] font-black uppercase">Visto Bueno Unidad</p>
                    <p class="text-[9px] text-gray-500 uppercase">Obras Públicas</p>
                </div>
            </div>

            <div class="mt-8 text-[8px] italic text-gray-400 text-right">
                Documento generado por el Sistema de Seguimiento de Arboricultura - Koffys Systems v2.5
            </div>
        </div>
    </div>
</template>

<style scoped>
.reportes-container {
    padding: 2rem;
}

@media print {
    @page {
        size: A4 landscape;
        margin: 1cm;
    }
    
    body * {
        visibility: hidden;
    }
    
    .bulk-print-layout, .bulk-print-layout * {
        visibility: visible;
    }
    
    .bulk-print-layout {
        position: absolute;
        left: 0;
        top: 0;
        width: 100%;
        color: black !important;
    }

    .no-print {
        display: none !important;
    }
}

.animate-fade-in {
    animation: fadeIn 0.3s ease-out;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}
</style>
