<template>
<div>
    <div id="dashboard">
        <!-- Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <div class="stat-card card p-6">
                <div class="flex justify-between items-start">
                    <div>
                        <p class="text-white/80 text-sm font-medium mb-2">
                            Total Solicitudes
                        </p>
                        <p class="text-4xl font-bold">{{ stats.total }}</p>
                        <p class="text-white/70 text-xs mt-2">Registradas en el sistema</p>
                    </div>
                    <svg class="w-12 h-12 opacity-20" fill="currentColor" viewBox="0 0 20 20">
                        <path
                            d="M4 4a2 2 0 00-2 2v4a2 2 0 002 2V6h10a2 2 0 00-2-2H4zm2 6a2 2 0 012-2h8a2 2 0 012 2v4a2 2 0 01-2 2H8a2 2 0 01-2-2v-4zm6-4a2 2 0 100-4 2 2 0 000 4z">
                        </path>
                    </svg>
                </div>
            </div>

            <div class="stat-card alt1 card p-6">
                <div class="flex justify-between items-start">
                    <div>
                        <p class="text-white/80 text-sm font-medium mb-2">
                            Completadas
                        </p>
                        <p class="text-4xl font-bold">{{ stats.completadas }}</p>
                        <p class="text-white/70 text-xs mt-2">
                            {{ stats.porcentaje_completadas }}% completadas
                        </p>
                    </div>
                    <svg class="w-12 h-12 opacity-20" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd"
                            d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                            clip-rule="evenodd"></path>
                    </svg>
                </div>
            </div>

            <div class="stat-card alt2 card p-6">
                <div class="flex justify-between items-start">
                    <div>
                        <p class="text-white/80 text-sm font-medium mb-2">
                            En Proceso / Espera
                        </p>
                        <p class="text-4xl font-bold">{{ stats.enProceso }}</p>
                        <p class="text-white/70 text-xs mt-2">
                            Trámites activos
                        </p>
                    </div>
                    <svg class="w-12 h-12 opacity-20" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd"
                            d="M4 2a1 1 0 011 1v2.101a7.002 7.002 0 0111.601 2.566 1 1 0 11-1.947.34A5.002 5.002 0 005.09 5.1A1 1 0 014 4.1V3a1 1 0 011-1zm.008 9a1 1 0 011.992 0 5 5 0 1019 0 1 1 0 11-2 0 3 3 0 10-6 0 1 1 0 01-1-1zm9-6a1 1 0 100-2 1 1 0 000 2z"
                            clip-rule="evenodd"></path>
                    </svg>
                </div>
            </div>

            <div class="stat-card alt3 card p-6">
                <div class="flex justify-between items-start">
                    <div>
                        <p class="text-white/80 text-sm font-medium mb-2">
                            Emergencia / Urgentes
                        </p>
                        <p class="text-4xl font-bold">{{ stats.urgentes }}</p>
                        <p class="text-white/70 text-xs mt-2">
                            Requieren atención rápida
                        </p>
                    </div>
                    <svg class="w-12 h-12 opacity-20" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd"
                            d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z"
                            clip-rule="evenodd"></path>
                    </svg>
                </div>
            </div>
        </div>

        <!-- Filters -->
        <div class="mb-6 flex flex-wrap gap-4 items-center">
            <div class="flex-1 min-w-[200px]">
                <label class="block text-sm font-semibold text-gray-700 mb-2">Filtrar por Período</label>
                <select class="search-input w-full border rounded p-2">
                    <option>Últimos 30 días</option>
                    <option>Últimos 3 meses</option>
                    <option>Este año</option>
                    <option>Todo el tiempo</option>
                </select>
            </div>
            <div class="flex-1 min-w-[200px]">
                <label class="block text-sm font-semibold text-gray-700 mb-2">Filtrar por Estado</label>
                <select class="search-input w-full border rounded p-2">
                    <option value="">Todos los estados</option>
                    <option value="En espera">En espera</option>
                    <option value="Terminado">Terminado</option>
                </select>
            </div>
            <div class="flex-1 min-w-[200px]">
                <label class="block text-sm font-semibold text-gray-700 mb-2">Filtrar por Distrito</label>
                <select class="search-input w-full border rounded p-2">
                    <option value="">Todos los distritos</option>
                    <option v-for="d in store.distritos" :key="d.id" :value="d.id">{{ d.nombre }}</option>
                </select>
            </div>
        </div>

        <!-- Charts -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
            <div class="chart-container card p-6">
                <h3 class="font-bold text-lg text-gray-800 mb-4 border-b pb-2">
                    Solicitudes por Distrito
                </h3>
                <div style="position: relative; height:300px; width:100%; display: flex; justify-content: center;">
                    <canvas id="chartPie"></canvas>
                </div>
            </div>

            <div class="chart-container card p-6">
                <h3 class="font-bold text-lg text-gray-800 mb-4 border-b pb-2">
                    Solicitudes por Acción Solicitada
                </h3>
                <div style="position: relative; height:300px; width:100%; display: flex; justify-content: center;">
                    <canvas id="chartBar"></canvas>
                </div>
            </div>
        </div>

        <!-- Recent Solicitudes Table -->
        <div class="card p-6 mt-8">
            <h3 class="font-bold text-lg text-gray-800 mb-4 border-b pb-2">
                Últimas Solicitudes Ingresadas
            </h3>
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 text-gray-700 text-sm">
                            <th class="p-3 border-b font-semibold">Código Interno</th>
                            <th class="p-3 border-b font-semibold">Fecha Ingreso</th>
                            <th class="p-3 border-b font-semibold">Solicitante</th>
                            <th class="p-3 border-b font-semibold">Ubicación</th>
                            <th class="p-3 border-b font-semibold">Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-if="ultimasSolicitudes.length === 0">
                            <td colspan="5" class="p-4 text-center text-gray-500">No hay solicitudes registradas aún.</td>
                        </tr>
                        <tr v-for="(sol, index) in ultimasSolicitudes" :key="index" class="hover:bg-gray-50 border-b last:border-0 transition-colors">
                            <td class="p-3 text-sm font-medium text-blue-600">{{ sol.comunicacion_interna || 'Sin código' }}</td>
                            <td class="p-3 text-sm text-gray-600">{{ sol.fecha_ingreso }}</td>
                            <td class="p-3 text-sm font-medium">{{ sol.solicitante_nombre }}</td>
                            <td class="p-3 text-sm text-gray-600">
                                {{ getBarrioNombre(sol.id_barrio) }}
                                <span v-if="sol.id_nombre_institucional" class="text-xs bg-purple-100 text-purple-800 px-2 py-0.5 rounded ml-1">
                                    Inst
                                </span>
                            </td>
                            <td class="p-3 text-sm">
                                <span class="px-3 py-1 rounded-full text-xs font-semibold"
                                    :class="sol.estado_tramite === 'Terminado' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'">
                                    {{ sol.estado_tramite }}
                                </span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="mt-4 text-right">
                <button @click="$router.push('/solicitudes')" class="text-blue-600 hover:text-blue-800 text-sm font-medium">
                    Ver todas las solicitudes →
                </button>
            </div>
        </div>
    </div>
</div>
</template>
<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import { store } from '../store/data.js'

// --- ESTADÍSTICAS GLOBALES ---
const stats = computed(() => {
    const total = store.solicitudes.length;
    const completadas = store.solicitudes.filter(s => s.estado_tramite === 'Terminado').length;
    const enProceso = total - completadas;
    const urgentes = store.solicitudes.filter(s => s.nivel_urgencia === 'Alta' || s.es_emergencia).length;
    
    return {
        total,
        completadas,
        enProceso,
        urgentes,
        porcentaje_completadas: total > 0 ? ((completadas / total) * 100).toFixed(1) : 0
    }
})

// Computed para obtener las últimas 5 solicitudes
const ultimasSolicitudes = computed(() => {
    return [...store.solicitudes].reverse().slice(0, 5)
})

const getBarrioNombre = (id) => {
    if (!id) return 'N/A'
    const b = store.barrios.find(x => x.id === id)
    return b ? b.nombre : 'Desconocido'
}

// --- GRÁFICOS CON CHART.JS ---
let chartPieInstance = null;
let chartBarInstance = null;

const generarDatosGraficos = () => {
    // 1. Solicitudes por Distrito
    const countPorDistrito = {};
    // 2. Solicitudes por Acción Solicitada
    const countPorAccion = {};

    store.solicitudes.forEach(s => {
        // Distrito
        if (s.id_barrio) {
            const barrio = store.barrios.find(b => b.id === s.id_barrio);
            if (barrio) {
                const distId = barrio.id_distrito;
                countPorDistrito[distId] = (countPorDistrito[distId] || 0) + 1;
            }
        }
        // Acciones
        if (s.id_accion_solicitada) {
            const accion = store.acciones.find(a => a.id === s.id_accion_solicitada);
            if (accion) {
                const nombreCorto = accion.nombre.split('–')[0].split('-')[0].trim();
                countPorAccion[nombreCorto] = (countPorAccion[nombreCorto] || 0) + 1;
            }
        }
    });

    const etiquetasDistrito = Object.keys(countPorDistrito).map(id => `Distrito ${id}`);
    const valoresDistrito = Object.values(countPorDistrito);

    const etiquetasAccion = Object.keys(countPorAccion);
    const valoresAccion = Object.values(countPorAccion);

    return {
        distritos: { labels: etiquetasDistrito, data: valoresDistrito },
        acciones: { labels: etiquetasAccion, data: valoresAccion }
    }
}

const renderCharts = () => {
    if (!window.Chart) return; // Por si el CDN falla

    const datos = generarDatosGraficos();

    // Destruir gráficos anteriores si existen para redibujarlos limpios
    if (chartPieInstance) chartPieInstance.destroy();
    if (chartBarInstance) chartBarInstance.destroy();

    // Gráfico de Pastel (Distritos)
    const ctxPie = document.getElementById('chartPie');
    if (ctxPie) {
        chartPieInstance = new window.Chart(ctxPie, {
            type: 'doughnut',
            data: {
                labels: datos.distritos.labels.length > 0 ? datos.distritos.labels : ['Sin datos'],
                datasets: [{
                    data: datos.distritos.data.length > 0 ? datos.distritos.data : [1],
                    backgroundColor: ['#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#06b6d4'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'bottom' }
                }
            }
        });
    }

    // Gráfico de Barras (Acciones)
    const ctxBar = document.getElementById('chartBar');
    if (ctxBar) {
        chartBarInstance = new window.Chart(ctxBar, {
            type: 'bar',
            data: {
                labels: datos.acciones.labels.length > 0 ? datos.acciones.labels : ['Sin datos'],
                datasets: [{
                    label: 'Cantidad',
                    data: datos.acciones.data.length > 0 ? datos.acciones.data : [0],
                    backgroundColor: '#3b82f6',
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: { beginAtZero: true, ticks: { stepSize: 1 } }
                }
            }
        });
    }
}

onMounted(() => {
    renderCharts();
})

// Si store.solicitudes cambia (se agrega una nueva), redibujar gráficos automáticamente
watch(() => store.solicitudes.length, () => {
    renderCharts();
})
</script>