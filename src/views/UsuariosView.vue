<template>
<div>
    <div id="usuarios">
        <div class="mb-6">
            <h2 class="text-2xl font-bold text-gray-800 mb-2">
                Gestión de Usuarios
            </h2>
            <p class="text-gray-600">
                Administra los usuarios del sistema y sus permisos de acceso
            </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div class="card p-6">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="font-bold text-lg text-gray-800">
                        Total Usuarios
                    </h3>
                    <svg class="w-8 h-8 text-blue-500" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z"></path>
                    </svg>
                </div>
                <p class="text-3xl font-bold text-gray-800">24</p>
                <p class="text-gray-600 text-sm mt-2">
                    Activos en el sistema
                </p>
            </div>

            <div class="card p-6">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="font-bold text-lg text-gray-800">
                        Administradores
                    </h3>
                    <svg class="w-8 h-8 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd"
                            d="M11.49 3.17c-.38-1.56-2.6-1.56-2.98 0a1.532 1.532 0 01-2.286.948c-1.372-.836-2.942.734-2.106 2.106.54.886.061 2.042-.947 2.287-1.561.379-1.561 2.6 0 2.978a1.532 1.532 0 01.947 2.287c-.836 1.372.734 2.942 2.106 2.106a1.532 1.532 0 012.287.947c.379 1.561 2.6 1.561 2.978 0a1.533 1.533 0 012.287-.947c1.372.836 2.942-.734 2.106-2.106a1.533 1.533 0 01.947-2.287c1.561-.379 1.561-2.6 0-2.978a1.532 1.532 0 01-.947-2.287c.836-1.372-.734-2.942-2.106-2.106a1.532 1.532 0 01-2.287-.947zm-.196 9.307a3 3 0 100-6 3 3 0 000 6z"
                            clip-rule="evenodd"></path>
                    </svg>
                </div>
                <p class="text-3xl font-bold text-gray-800">3</p>
                <p class="text-gray-600 text-sm mt-2">Con permisos totales</p>
            </div>

            <div class="card p-6">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="font-bold text-lg text-gray-800">Operarios</h3>
                    <svg class="w-8 h-8 text-orange-500" fill="currentColor" viewBox="0 0 20 20">
                        <path
                            d="M10.5 1.5H5.75A2.75 2.75 0 0 0 3 4.25v11.5A2.75 2.75 0 0 0 5.75 18.5h8.5A2.75 2.75 0 0 0 17 15.75V8">
                        </path>
                    </svg>
                </div>
                <p class="text-3xl font-bold text-gray-800">21</p>
                <p class="text-gray-600 text-sm mt-2">Ejecutando trabajos</p>
            </div>
        </div>

        <div class="card p-6 mt-6">
            <div class="flex justify-between items-center mb-4">
                <h3 class="font-bold text-lg text-gray-800">
                    Directorio de Usuarios Activos
                </h3>
                <button class="btn-primary text-sm px-4 py-2 bg-blue-600 text-white rounded shadow hover:bg-blue-700">
                    + Nuevo Usuario
                </button>
            </div>
            
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 text-gray-700 text-sm border-b">
                            <th class="p-3 font-semibold">Nombre Completo</th>
                            <th class="p-3 font-semibold">Rol</th>
                            <th class="p-3 font-semibold">Correo Electrónico</th>
                            <th class="p-3 font-semibold">Último Acceso</th>
                            <th class="p-3 font-semibold">Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="user in usuariosMuestra" :key="user.id" class="border-b last:border-0 hover:bg-gray-50">
                            <td class="p-3 font-medium text-gray-800">{{ user.nombre }}</td>
                            <td class="p-3">
                                <span class="text-xs px-2 py-1 rounded font-semibold"
                                    :class="user.rol === 'Administrador' ? 'bg-purple-100 text-purple-800' : 'bg-blue-100 text-blue-800'">
                                    {{ user.rol }}
                                </span>
                            </td>
                            <td class="p-3 text-sm text-gray-600">{{ user.email }}</td>
                            <td class="p-3 text-sm text-gray-500">{{ user.ultimo_acceso }}</td>
                            <td class="p-3">
                                <span class="text-xs text-green-700 bg-green-100 px-2 py-1 rounded-full font-semibold border border-green-200">
                                    Activo
                                </span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</template>

<script setup>
import { ref } from 'vue'

const usuariosMuestra = ref([
    { id: 1, nombre: 'Kevin Flores Vallejos', rol: 'Administrador', email: 'Systemaskoffys@gmail.com', ultimo_acceso: 'Hace 5 min' },
    { id: 2, nombre: 'Ing. Cimar Farfan', rol: 'Supervisor', email: 'cfarfan@alcaldiatarija.gob.bo', ultimo_acceso: 'Hace 1 hora' },
    { id: 3, nombre: 'María Secretaria', rol: 'Recepción', email: 'recepcion@alcaldiatarija.gob.bo', ultimo_acceso: 'Hace 2 horas' }
])
</script>