<template>
  <div class="flex h-screen bg-gray-50 print:bg-white print:h-auto">
    <Sidebar class="print:hidden" />
    <div class="flex-1 flex flex-col overflow-hidden print:overflow-visible print:bg-white">
        <div class="bg-white border-b border-gray-200 px-8 py-6 shadow-sm print:hidden">
            <div class="breadcrumb">
                Sistema de Seguimiento de Área de Arboricultura >
                <span id="breadcrumb-section">{{ routeName }}</span>
            </div>
            <h1 class="page-title">{{ routeTitle }}</h1>
            <p class="page-subtitle">{{ routeSubtitle }}</p>
        </div>
        <div class="flex-1 overflow-y-auto print:overflow-visible">
            <div class="main-content p-8 print:p-0">
                <router-view></router-view>
            </div>
        </div>
    </div>
    <SolicitudModal v-if="uiState.showModal" @close="uiState.showModal = false" />
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import { useRoute } from 'vue-router'
import Sidebar from './components/Sidebar.vue'
import SolicitudModal from './components/SolicitudModal.vue'
import { uiState } from './store/data.js'

const route = useRoute()

const routeName = computed(() => {
    const map = {
        dashboard: "Dashboard",
        solicitudes: "Gestión de Solicitudes",
        usuarios: "Usuarios",
        configuraciones: "Configuraciones",
        acerca: "Acerca de"
    }
    return map[route.name] || 'Dashboard'
})

const routeTitle = computed(() => {
    const map = {
        dashboard: "Panel de Control",
        solicitudes: "Gestión de Solicitudes",
        usuarios: "Gestión de Usuarios",
        configuraciones: "Configuraciones del Sistema",
        acerca: "Créditos e Información Institucional"
    }
    return map[route.name] || 'Panel de Control'
})

const routeSubtitle = computed(() => {
    const map = {
        dashboard: "Visualiza el estado general del sistema y tus solicitudes activas",
        solicitudes: "Administra todas las solicitudes de podas y derribos del sistema",
        usuarios: "Administra los usuarios del sistema y sus permisos de acceso",
        configuraciones: "Ajusta los parámetros y configuraciones generales del sistema",
        acerca: "Información técnica, políticas de privacidad y datos del desarrollador"
    }
    return map[route.name] || ''
})
</script>
