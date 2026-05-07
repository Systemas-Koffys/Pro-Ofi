<template>
<div class="sidebar w-80 flex flex-col text-white overflow-y-auto">
        <div class="h-20 flex items-center px-6 border-b border-white/10 mb-6">
            <div class="flex items-center space-x-3">
                <div class="w-10 h-10 bg-white/20 rounded-lg flex items-center justify-center">
                    <span class="text-white text-xl">🌳</span>
                </div>
                <div>
                    <h1 class="text-white font-bold leading-tight">Seguimiento<br>Arboricultura</h1>
                    <p class="text-green-300 text-xs">Obras Públicas Tarija</p>
                </div>
            </div>
        </div>

            <nav class="flex-1 p-4 space-y-2">
                <div class="nav-item p-4 rounded-lg cursor-pointer" :class="{ active: $route.path === '/' }" @click="$router.push('/')">
                    <div class="flex items-center">
                        <svg class="w-5 h-5 mr-3" fill="currentColor" viewBox="0 0 20 20">
                            <path
                                d="M2 11a1 1 0 011-1h2a1 1 0 011 1v5a1 1 0 01-1 1H3a1 1 0 01-1-1v-5zM8 7a1 1 0 011-1h2a1 1 0 011 1v9a1 1 0 01-1 1H9a1 1 0 01-1-1V7zM14 4a1 1 0 011-1h2a1 1 0 011 1v12a1 1 0 01-1 1h-2a1 1 0 01-1-1V4z">
                            </path>
                        </svg>
                        <span class="font-semibold">Dashboard</span>
                    </div>
                </div>

                <div class="nav-item p-4 rounded-lg cursor-pointer" :class="{ active: $route.path === '/solicitudes' }" @click="$router.push('/solicitudes')">
                    <div class="flex items-center">
                        <svg class="w-5 h-5 mr-3" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd"
                                d="M4 4a2 2 0 00-2 2v4a2 2 0 002 2V6h10a2 2 0 00-2-2H4zm2 6a2 2 0 012-2h8a2 2 0 012 2v4a2 2 0 01-2 2H8a2 2 0 01-2-2v-4zm6-4a2 2 0 100-4 2 2 0 000 4z"
                                clip-rule="evenodd"></path>
                        </svg>
                        <span class="font-semibold">Gestión de Solicitudes</span>
                    </div>
                </div>

                <div class="nav-item p-4 rounded-lg cursor-pointer" :class="{ active: $route.path === '/usuarios' }" @click="$router.push('/usuarios')">
                    <div class="flex items-center">
                        <svg class="w-5 h-5 mr-3" fill="currentColor" viewBox="0 0 20 20">
                            <path d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z"></path>
                        </svg>
                        <span class="font-semibold">Usuarios</span>
                    </div>
                </div>

                <div class="nav-item p-4 rounded-lg cursor-pointer" :class="{ active: $route.path === '/configuraciones' }" @click="$router.push('/configuraciones')">
                    <div class="flex items-center">
                        <svg class="w-5 h-5 mr-3" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd"
                                d="M11.49 3.17c-.38-1.56-2.6-1.56-2.98 0a1.532 1.532 0 01-2.286.948c-1.372-.836-2.942.734-2.106 2.106.54.886.061 2.042-.947 2.287-1.561.379-1.561 2.6 0 2.978a1.532 1.532 0 01.947 2.287c-.836 1.372.734 2.942 2.106 2.106a1.532 1.532 0 012.287.947c.379 1.561 2.6 1.561 2.978 0a1.533 1.533 0 012.287-.947c1.372.836 2.942-.734 2.106-2.106a1.533 1.533 0 01.947-2.287c1.561-.379 1.561-2.6 0-2.978a1.532 1.532 0 01-.947-2.287c.836-1.372-.734-2.942-2.106-2.106a1.532 1.532 0 01-2.287-.947zm-.196 9.307a3 3 0 100-6 3 3 0 000 6z"
                                clip-rule="evenodd"></path>
                        </svg>
                        <span class="font-semibold">Configuraciones</span>
                    </div>
                </div>
            </nav>

            <div class="p-6 border-t border-white/10">
                <router-link to="/acerca" class="flex items-center text-white/80 hover:text-white transition-colors">
                    <span class="mr-3 opacity-80">ℹ️</span>
                    <span class="text-sm font-medium">Acerca del Sistema</span>
                </router-link>
                <p class="text-[10px] text-white/50 mt-3">v 2.5 - Systemas Koffy's</p>
            </div>
        </div>
</template>
<script setup></script>