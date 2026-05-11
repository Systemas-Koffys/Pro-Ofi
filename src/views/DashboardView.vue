<template>
<div class="dashboard p-2">
    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <div class="stat-card card p-6 border-l-4 border-l-accent">
            <div class="flex justify-between items-start">
                <div>
                    <p class="text-muted text-xs font-black uppercase tracking-widest mb-1">Total Solicitudes</p>
                    <p class="text-4xl font-black">{{ stats.total }}</p>
                    <p class="text-muted text-[10px] mt-2">Registradas en el sistema</p>
                </div>
                <div class="p-3 bg-accent/10 rounded-2xl text-accent">
                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                </div>
            </div>
        </div>

        <div class="stat-card card p-6 border-l-4 border-l-green-500">
            <div class="flex justify-between items-start">
                <div>
                    <p class="text-muted text-xs font-black uppercase tracking-widest mb-1">Completadas</p>
                    <p class="text-4xl font-black">{{ stats.completadas }}</p>
                    <p class="text-muted text-[10px] mt-2">{{ stats.porcentaje_completadas }}% del total</p>
                </div>
                <div class="p-3 bg-green-500/10 rounded-2xl text-green-500">
                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                </div>
            </div>
        </div>

        <div class="stat-card card p-6 border-l-4 border-l-yellow-500">
            <div class="flex justify-between items-start">
                <div>
                    <p class="text-muted text-xs font-black uppercase tracking-widest mb-1">En Proceso</p>
                    <p class="text-4xl font-black">{{ stats.enProceso }}</p>
                    <p class="text-muted text-[10px] mt-2">Trámites activos</p>
                </div>
                <div class="p-3 bg-yellow-500/10 rounded-2xl text-yellow-500">
                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                </div>
            </div>
        </div>

        <div class="stat-card card p-6 border-l-4 border-l-red-500">
            <div class="flex justify-between items-start">
                <div>
                    <p class="text-muted text-xs font-black uppercase tracking-widest mb-1">Urgentes</p>
                    <p class="text-4xl font-black">{{ stats.urgentes }}</p>
                    <p class="text-muted text-[10px] mt-2">Atención inmediata</p>
                </div>
                <div class="p-3 bg-red-500/10 rounded-2xl text-red-500">
                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg>
                </div>
            </div>
        </div>
    </div>

    <!-- Charts Row 1 -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
        <div class="card p-6">
            <h3 class="font-black text-lg mb-6 border-b border-border pb-4 uppercase tracking-tighter">
                Distribución por Distrito
            </h3>
            <div class="relative h-[300px] flex justify-center">
                <canvas id="chartPie"></canvas>
            </div>
        </div>

        <div class="card p-6">
            <h3 class="font-black text-lg mb-6 border-b border-border pb-4 uppercase tracking-tighter">
                Tipos de Acción Solicitada
            </h3>
            <div class="relative h-[300px] flex justify-center">
                <canvas id="chartBar"></canvas>
            </div>
        </div>
    </div>

    <!-- Charts Row 2 -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
        <div class="card p-6">
            <h3 class="font-black text-lg mb-6 border-b border-border pb-4 uppercase tracking-tighter text-accent">
                Top 10 Barrios con más Solicitudes
            </h3>
            <div class="relative h-[350px]">
                <canvas id="chartBarrios"></canvas>
            </div>
        </div>

        <div class="card p-6">
            <h3 class="font-black text-lg mb-6 border-b border-border pb-4 uppercase tracking-tighter text-blue-500">
                Evolución de Ingresos (Mensual)
            </h3>
            <div class="relative h-[350px]">
                <canvas id="chartEvolucion"></canvas>
            </div>
        </div>
    </div>

    <!-- Recent Solicitudes Table -->
    <div class="card p-8 overflow-hidden">
        <h3 class="font-black text-lg mb-6 border-b border-border pb-4 uppercase tracking-tighter flex items-center gap-2">
            <span class="w-2 h-2 bg-yellow-500 rounded-full animate-pulse"></span>
            Solicitudes Entrantes (En Espera)
        </h3>
        <div class="overflow-x-auto">
            <table class="w-full text-left">
                <thead>
                    <tr class="text-[10px] font-black uppercase text-muted tracking-widest">
                        <th class="py-3 px-4 border-b border-border">Código</th>
                        <th class="py-3 px-4 border-b border-border">Fecha</th>
                        <th class="py-3 px-4 border-b border-border">Solicitante</th>
                        <th class="py-3 px-4 border-b border-border">Barrio</th>
                        <th class="py-3 px-4 border-b border-border">Acción</th>
                        <th class="py-3 px-4 border-b border-border text-center">Urgencia</th>
                        <th class="py-3 px-4 border-b border-border text-center">Estado</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-if="ultimasSolicitudes.length === 0">
                        <td colspan="7" class="p-8 text-center text-muted font-bold">No hay registros en espera</td>
                    </tr>
                    <tr v-for="(sol, index) in ultimasSolicitudes" :key="index" class="hover:bg-accent/5 transition-colors">
                        <td class="py-4 px-4 border-b border-border text-sm font-black text-accent">{{ sol.comunicacion_interna || '---' }}</td>
                        <td class="py-4 px-4 border-b border-border text-xs font-bold">{{ sol.fecha_ingreso }}</td>
                        <td class="py-4 px-4 border-b border-border text-sm font-bold">{{ sol.solicitante_nombre }}</td>
                        <td class="py-4 px-4 border-b border-border text-xs font-bold">{{ getBarrioNombre(sol.id_barrio) }}</td>
                        <td class="py-4 px-4 border-b border-border text-xs font-bold truncate max-w-[150px]">{{ getAccionNombre(sol.id_accion_solicitada) }}</td>
                        <td class="py-4 px-4 border-b border-border text-center">
                            <span :class="['px-2 py-0.5 rounded text-[9px] font-black uppercase', 
                                sol.nivel_urgencia === 'Alta' || sol.es_emergencia ? 'bg-red-500 text-white' : 'bg-blue-500/10 text-blue-500']">
                                {{ sol.es_emergencia ? 'EMERGENCIA' : sol.nivel_urgencia }}
                            </span>
                        </td>
                        <td class="py-4 px-4 border-b border-border text-center">
                            <span class="px-3 py-1 rounded-lg text-[10px] font-black uppercase bg-yellow-500/10 text-yellow-500">
                                {{ sol.estado_tramite }}
                            </span>
                        </td>
                    </tr>
                </tbody>
            </table>
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

// Computed para obtener las últimas 10 solicitudes en espera
const ultimasSolicitudes = computed(() => {
    return store.solicitudes
        .filter(s => s.estado_tramite === 'En espera')
        .reverse()
        .slice(0, 10)
})

const getBarrioNombre = (id) => {
    if (!id) return '---'
    const b = store.barrios.find(x => x.id == id)
    return b ? b.nombre : '---'
}

const getAccionNombre = (id) => {
    if (!id) return '---'
    const a = store.acciones.find(x => x.id == id)
    return a ? a.nombre.split('–')[0].split('-')[0].trim() : '---'
}

// --- GRÁFICOS CON CHART.JS ---
let chartPieInstance = null;
let chartBarInstance = null;
let chartBarriosInstance = null;
let chartEvolucionInstance = null;

const generarDatosGraficos = () => {
    // 1. Solicitudes por Distrito
    const countPorDistrito = {};
    // 2. Solicitudes por Acción Solicitada
    const countPorAccion = {};
    // 3. Solicitudes por Barrio (Top 10)
    const countPorBarrio = {};
    // 4. Evolución Mensual
    const countPorMes = {};

    const mesesNombres = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];

    store.solicitudes.forEach(s => {
        // Distrito
        if (s.id_barrio) {
            const barrio = store.barrios.find(b => b.id === s.id_barrio);
            if (barrio) {
                const distId = barrio.id_distrito;
                countPorDistrito[distId] = (countPorDistrito[distId] || 0) + 1;
                
                // Barrios
                countPorBarrio[barrio.nombre] = (countPorBarrio[barrio.nombre] || 0) + 1;
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
        // Evolución (Fecha de Ingreso)
        if (s.fecha_ingreso) {
            const fecha = new Date(s.fecha_ingreso);
            const mesAnio = `${mesesNombres[fecha.getMonth()]} ${fecha.getFullYear()}`;
            countPorMes[mesAnio] = (countPorMes[mesAnio] || 0) + 1;
        }
    });

    // Ordenar y limitar Barrios
    const topBarrios = Object.entries(countPorBarrio)
        .sort((a, b) => b[1] - a[1])
        .slice(0, 10);

    // Ordenar Meses (Simplificado: asume orden cronológico por inserción o requiere sorting real)
    const etiquetasMes = Object.keys(countPorMes);
    const valoresMes = Object.values(countPorMes);

    return {
        distritos: { 
            labels: Object.keys(countPorDistrito).map(id => `Distrito ${id}`), 
            data: Object.values(countPorDistrito) 
        },
        acciones: { 
            labels: Object.keys(countPorAccion), 
            data: Object.values(countPorAccion) 
        },
        barrios: { 
            labels: topBarrios.map(b => b[0]), 
            data: topBarrios.map(b => b[1]) 
        },
        evolucion: { 
            labels: etiquetasMes, 
            data: valoresMes 
        }
    }
}

const renderCharts = () => {
    if (!window.Chart) return;

    const datos = generarDatosGraficos();

    // Destruir instancias previas
    [chartPieInstance, chartBarInstance, chartBarriosInstance, chartEvolucionInstance].forEach(c => c?.destroy());

    // 1. Pastel (Distritos)
    chartPieInstance = new window.Chart(document.getElementById('chartPie'), {
        type: 'doughnut',
        data: {
            labels: datos.distritos.labels.length > 0 ? datos.distritos.labels : ['Sin datos'],
            datasets: [{
                data: datos.distritos.data.length > 0 ? datos.distritos.data : [1],
                backgroundColor: ['#6A8E40', '#3b82f6', '#8b5cf6', '#ef4444', '#f59e0b', '#06b6d4'],
                borderWidth: 0
            }]
        },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } } }
    });

    // 2. Barras (Acciones)
    chartBarInstance = new window.Chart(document.getElementById('chartBar'), {
        type: 'bar',
        data: {
            labels: datos.acciones.labels.length > 0 ? datos.acciones.labels : ['Sin datos'],
            datasets: [{
                label: 'Solicitudes',
                data: datos.acciones.data.length > 0 ? datos.acciones.data : [0],
                backgroundColor: '#3b82f6',
                borderRadius: 8
            }]
        },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } } }
    });

    // 3. Barrios (Horizontal)
    chartBarriosInstance = new window.Chart(document.getElementById('chartBarrios'), {
        type: 'bar',
        data: {
            labels: datos.barrios.labels.length > 0 ? datos.barrios.labels : ['Sin datos'],
            datasets: [{
                label: 'Solicitudes',
                data: datos.barrios.data.length > 0 ? datos.barrios.data : [0],
                backgroundColor: '#6A8E40',
                borderRadius: 5
            }]
        },
        options: {
            indexAxis: 'y',
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } }
        }
    });

    // 4. Evolución (Línea)
    chartEvolucionInstance = new window.Chart(document.getElementById('chartEvolucion'), {
        type: 'line',
        data: {
            labels: datos.evolucion.labels.length > 0 ? datos.evolucion.labels : ['Sin datos'],
            datasets: [{
                label: 'Ingresos',
                data: datos.evolucion.data.length > 0 ? datos.evolucion.data : [0],
                borderColor: '#3b82f6',
                backgroundColor: 'rgba(59, 130, 246, 0.1)',
                fill: true,
                tension: 0.4,
                pointRadius: 5,
                pointHoverRadius: 8
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true } }
        }
    });
}

onMounted(() => {
    renderCharts();
})

// Si store.solicitudes cambia (se agrega una nueva), redibujar gráficos automáticamente
watch(() => store.solicitudes.length, () => {
    renderCharts();
})
</script>