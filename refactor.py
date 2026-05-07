import os
import re

with open('index.html', 'r', encoding='utf-8') as f:
    html = f.read()

os.makedirs('src/views', exist_ok=True)
os.makedirs('src/components', exist_ok=True)
os.makedirs('src/router', exist_ok=True)

# Extract CSS
css_match = re.search(r'<style>(.*?)</style>', html, re.DOTALL)
if css_match:
    with open('src/style.css', 'w', encoding='utf-8') as f:
        f.write("@import 'tailwindcss';\n" + css_match.group(1).strip())

# Extract Sidebar
sidebar_match = re.search(r'<!-- SIDEBAR -->(.*?)<!-- MAIN CONTENT -->', html, re.DOTALL)
if sidebar_match:
    sidebar_content = sidebar_match.group(1).strip()
    # Simple replace of onclick to router-links
    sidebar_content = sidebar_content.replace('onclick="switchView(\'dashboard\')"', '@click="$router.push(\'/\')"')
    sidebar_content = sidebar_content.replace('onclick="switchView(\'solicitudes\')"', '@click="$router.push(\'/solicitudes\')"')
    sidebar_content = sidebar_content.replace('onclick="switchView(\'usuarios\')"', '@click="$router.push(\'/usuarios\')"')
    sidebar_content = sidebar_content.replace('onclick="switchView(\'configuraciones\')"', '@click="$router.push(\'/configuraciones\')"')
    
    with open('src/components/Sidebar.vue', 'w', encoding='utf-8') as f:
        f.write(f'<template>\n{sidebar_content}\n</template>\n<script setup></script>')

# Views extraction
views = [
    ('dashboard', r'<!-- VIEW: DASHBOARD -->(.*?)<!-- VIEW: GESTIÓN DE SOLICITUDES -->'),
    ('solicitudes', r'<!-- VIEW: GESTIÓN DE SOLICITUDES -->(.*?)<!-- VIEW: USUARIOS -->'),
    ('usuarios', r'<!-- VIEW: USUARIOS -->(.*?)<!-- VIEW: CONFIGURACIONES -->'),
    ('configuraciones', r'<!-- VIEW: CONFIGURACIONES -->(.*?)</div>\s*</div>\s*</div>\s*</div>\s*<!-- MODAL FOR NEW SOLICITUD -->')
]

for view_name, pattern in views:
    match = re.search(pattern, html, re.DOTALL)
    if match:
        content = match.group(1).strip()
        filename = view_name.capitalize() + 'View.vue'
        with open(f'src/views/{filename}', 'w', encoding='utf-8') as f:
            f.write(f'<template>\n{content}\n</template>\n<script setup></script>')

# Extract Modal
modal_match = re.search(r'<!-- MODAL FOR NEW SOLICITUD -->(.*?)<script>', html, re.DOTALL)
if modal_match:
    modal_content = modal_match.group(1).strip()
    with open('src/components/SolicitudModal.vue', 'w', encoding='utf-8') as f:
        f.write(f'<template>\n{modal_content}\n</template>\n<script setup></script>')

# Create Router
router_code = """import { createRouter, createWebHistory } from 'vue-router'
import DashboardView from '../views/DashboardView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', name: 'dashboard', component: DashboardView },
    { path: '/solicitudes', name: 'solicitudes', component: () => import('../views/SolicitudesView.vue') },
    { path: '/usuarios', name: 'usuarios', component: () => import('../views/UsuariosView.vue') },
    { path: '/configuraciones', name: 'configuraciones', component: () => import('../views/ConfiguracionesView.vue') }
  ]
})
export default router
"""
with open('src/router/index.js', 'w', encoding='utf-8') as f:
    f.write(router_code)

# Create App.vue
app_code = """<template>
  <div class="flex h-screen bg-gray-50">
    <Sidebar />
    <div class="flex-1 flex flex-col overflow-hidden">
        <div class="bg-white border-b border-gray-200 px-8 py-6 shadow-sm">
            <div class="breadcrumb">
                Sistema de Gestión de Podas >
                <span id="breadcrumb-section">{{ routeName }}</span>
            </div>
            <h1 class="page-title">{{ routeTitle }}</h1>
            <p class="page-subtitle">{{ routeSubtitle }}</p>
        </div>
        <div class="flex-1 overflow-y-auto">
            <div class="main-content p-8">
                <router-view></router-view>
            </div>
        </div>
    </div>
    <SolicitudModal v-if="showModal" @close="showModal = false" />
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import { useRoute } from 'vue-router'
import Sidebar from './components/Sidebar.vue'
import SolicitudModal from './components/SolicitudModal.vue'

const route = useRoute()
const showModal = ref(false)

const routeName = computed(() => {
    const map = {
        dashboard: "Dashboard",
        solicitudes: "Gestión de Solicitudes",
        usuarios: "Usuarios",
        configuraciones: "Configuraciones",
    }
    return map[route.name] || 'Dashboard'
})

const routeTitle = computed(() => {
    const map = {
        dashboard: "Panel de Control",
        solicitudes: "Gestión de Solicitudes",
        usuarios: "Gestión de Usuarios",
        configuraciones: "Configuraciones del Sistema",
    }
    return map[route.name] || 'Panel de Control'
})

const routeSubtitle = computed(() => {
    const map = {
        dashboard: "Visualiza el estado general del sistema y tus solicitudes activas",
        solicitudes: "Administra todas las solicitudes de podas y derribles del sistema",
        usuarios: "Administra los usuarios del sistema y sus permisos de acceso",
        configuraciones: "Ajusta los parámetros y configuraciones generales del sistema",
    }
    return map[route.name] || ''
})
</script>
"""
with open('src/App.vue', 'w', encoding='utf-8') as f:
    f.write(app_code)

# Create main.js
main_code = """import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'

const app = createApp(App)
app.use(router)
app.mount('#app')
"""
with open('src/main.js', 'w', encoding='utf-8') as f:
    f.write(main_code)

# Create new index.html
index_code = """<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sistema de Gestión de Podas v1.0</title>
    <!-- Chart.js via CDN -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
</head>
<body>
    <div id="app"></div>
    <script type="module" src="/src/main.js"></script>
</body>
</html>
"""
with open('index.html', 'w', encoding='utf-8') as f:
    f.write(index_code)

print("Refactor completed successfully!")
