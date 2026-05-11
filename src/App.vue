<template>
  <div v-if="uiState.user" :class="['flex h-screen overflow-hidden app-container', `theme-${uiState.theme}`]">
    <Sidebar class="print:hidden" />
    
    <div class="flex-1 flex flex-col min-w-0 bg-main overflow-hidden">
      <!-- Header Dinámico -->
      <header class="header-bar print:hidden">
        <div class="breadcrumb">
          Admin Portal > <span class="text-accent">{{ routeName }}</span>
        </div>
        <div class="flex justify-between items-end mt-1">
          <div>
            <h1 class="page-title">{{ routeTitle }}</h1>
            <p class="page-subtitle">{{ routeSubtitle }}</p>
          </div>
          
          <!-- Selector de Temas Minimalista -->
          <div class="flex bg-card p-1 rounded-xl border border-border">
            <button 
              v-for="t in ['white', 'black', 'colors']" 
              :key="t"
              @click="setTheme(t)"
              :class="['w-8 h-8 rounded-lg flex items-center justify-center transition-all', 
                       uiState.theme === t ? 'bg-accent text-white shadow-lg' : 'hover:bg-accent/10 text-muted']"
            >
              <div :class="['w-4 h-4 rounded-full border border-white/20', 
                           t === 'white' ? 'bg-white' : t === 'black' ? 'bg-black' : 'bg-purple-500']"></div>
            </button>
          </div>
        </div>
      </header>

      <!-- Área de Contenido Principal -->
      <main class="flex-1 overflow-y-auto p-6 scroll-smooth">
        <div class="max-w-[1600px] mx-auto h-full">
          <router-view v-slot="{ Component }">
            <transition name="fade" mode="out-in">
              <component :is="Component" />
            </transition>
          </router-view>
        </div>
      </main>
    </div>

    <!-- Modales y Notificaciones -->
    <SolicitudModal v-if="uiState.showModal" @close="uiState.showModal = false" />
    
    <Transition name="toast">
      <div v-if="toast.visible" class="toast-wrapper" :class="`toast-${toast.type}`">
        <div class="toast-icon">
          <component :is="toast.type === 'success' ? CheckCircle : AlertCircle" size="20" />
        </div>
        <div>
          <p class="toast-title">{{ toast.type === 'success' ? 'Éxito' : 'Error' }}</p>
          <p class="toast-msg">{{ toast.message }}</p>
        </div>
        <div class="toast-bar"></div>
      </div>
    </Transition>
  </div>
  <LoginView v-else />
</template>

<script setup>
import { computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { CheckCircle, AlertCircle } from 'lucide-vue-next'
import Sidebar from './components/Sidebar.vue'
import LoginView from './views/LoginView.vue'
import SolicitudModal from './components/SolicitudModal.vue'
import { uiState, toast, fetchCatalogos, fetchSolicitudes } from './store/data.js'

const route = useRoute()

onMounted(async () => {
    const savedTheme = localStorage.getItem('theme') || 'white'
    uiState.theme = savedTheme
    await fetchCatalogos()
    await fetchSolicitudes()
})

const setTheme = (t) => {
    uiState.theme = t
    localStorage.setItem('theme', t)
}

const routeName = computed(() => {
    const map = {
        dashboard: "Dashboard",
        solicitudes: "Gestión",
        personal: "Personal",
        usuarios: "Usuarios",
        configuraciones: "Configuración",
        acerca: "Información"
    }
    return map[route.name] || 'Inicio'
})

const routeTitle = computed(() => {
    const map = {
        dashboard: "Panel de Control",
        solicitudes: "Gestión de Solicitudes",
        personal: "Directorio de Personal",
        usuarios: "Administración de Usuarios",
        configuraciones: "Ajustes del Sistema",
        acerca: "Información Institucional"
    }
    return map[route.name] || 'Bienvenido'
})

const routeSubtitle = computed(() => {
    const map = {
        dashboard: "Resumen operativo del sistema y solicitudes en tiempo real",
        solicitudes: "Listado completo y administración de órdenes de trabajo",
        personal: "Gestión de fichas técnicas, cargos y contratos",
        usuarios: "Control de acceso y perfiles de usuario",
        configuraciones: "Parámetros globales y personalización",
        acerca: "Detalles del sistema y políticas de privacidad"
    }
    return map[route.name] || ''
})
</script>

<style>
.fade-enter-active, .fade-leave-active { transition: opacity 0.2s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }

.toast-wrapper {
  position: fixed; bottom: 30px; right: 30px; z-index: 9999;
  display: flex; align-items: center; gap: 12px;
  min-width: 300px; padding: 16px 20px; border-radius: 16px;
  box-shadow: 0 10px 40px rgba(0,0,0,0.2); overflow: hidden;
  background: var(--bg-card);
  border: 1px solid var(--border);
}
.toast-success { border-left: 4px solid #10b981; }
.toast-error { border-left: 4px solid #ef4444; }

.toast-success .toast-icon { color: #10b981; }
.toast-error .toast-icon { color: #ef4444; }

.toast-title { font-size: 14px; font-weight: 900; color: var(--text-main); text-transform: uppercase; }
.toast-msg { font-size: 13px; color: var(--text-muted); font-weight: 500; }
.toast-bar { position: absolute; bottom: 0; left: 0; height: 3px; width: 100%; background: var(--accent); opacity: 0.3; animation: shrink 3.5s linear forwards; }

@keyframes shrink { from { width: 100%; } to { width: 0%; } }
.toast-enter-active { animation: slideIn 0.3s cubic-bezier(0.34,1.56,0.64,1); }
.toast-leave-active { animation: slideOut 0.2s ease-in forwards; }
@keyframes slideIn { from { transform: translateX(120%); } to { transform: translateX(0); } }
@keyframes slideOut { from { transform: translateX(0); } to { transform: translateX(120%); } }
</style>
