<template>
<div>
<div id="configuraciones" >
                        <div class="mb-6">
                            <h2 class="text-2xl font-bold text-gray-800 mb-2">
                                Configuraciones del Sistema
                            </h2>
                            <p class="text-gray-600">
                                Ajusta los parámetros y configuraciones generales del sistema
                            </p>
                        </div>

                        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                            <div class="card p-6">
                                <h3 class="font-bold text-lg text-gray-800 mb-4">General</h3>
                                <div class="space-y-4">
                                    <div class="form-group">
                                        <label>Nombre de la Institución</label>
                                        <input type="text" value="Municipalidad" class="w-full" />
                                    </div>
                                    <div class="form-group">
                                        <label>Email de Contacto</label>
                                        <input type="email" value="contacto@municipalidad.gov" class="w-full" />
                                    </div>
                                    <div class="form-group">
                                        <label>Teléfono</label>
                                        <input type="tel" value="+34 123 456 789" class="w-full" />
                                    </div>
                                </div>
                            </div>

                            <div class="card p-6">
                                <h3 class="font-bold text-lg text-gray-800 mb-4">
                                    Notificaciones
                                </h3>
                                <div class="space-y-4">
                                    <div class="flex items-center justify-between">
                                        <label class="font-semibold text-gray-700">Notificaciones por Email</label>
                                        <label class="toggle-switch">
                                            <input type="checkbox" checked />
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                    <div class="flex items-center justify-between">
                                        <label class="font-semibold text-gray-700">Alertas de Urgencia</label>
                                        <label class="toggle-switch">
                                            <input type="checkbox" checked />
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                    <div class="flex items-center justify-between">
                                        <label class="font-semibold text-gray-700">Reportes Automáticos</label>
                                        <label class="toggle-switch">
                                            <input type="checkbox" />
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <div class="card p-6">
                                <h3 class="font-bold text-lg text-gray-800 mb-4">
                                    Información del Sistema
                                </h3>
                                <div class="space-y-3">
                                    <div class="flex justify-between border-b border-gray-200 pb-3">
                                        <span class="text-gray-600">Versión</span>
                                        <span class="font-semibold text-gray-800">1.0.0</span>
                                    </div>
                                    <div class="flex justify-between border-b border-gray-200 pb-3">
                                        <span class="text-gray-600">Última Actualización</span>
                                        <span class="font-semibold text-gray-800">05/05/2024</span>
                                    </div>
                                    <div class="flex justify-between">
                                        <span class="text-gray-600">Estado del Sistema</span>
                                        <span class="badge badge-completed">Operativo</span>
                                    </div>
                                </div>
                            </div>

                            <div class="card p-6">
                                <h3 class="font-bold text-lg text-gray-800 mb-4">Acciones</h3>
                                <div class="space-y-2">
                                    <button class="btn-primary w-full">
                                        <svg class="w-4 h-4 inline-block mr-2" fill="currentColor" viewBox="0 0 20 20">
                                            <path fill-rule="evenodd"
                                                d="M4 4a2 2 0 00-2 2v4a2 2 0 002 2V6h10a2 2 0 00-2-2H4zm2 6a2 2 0 012-2h8a2 2 0 012 2v4a2 2 0 01-2 2H8a2 2 0 01-2-2v-4zm6-4a2 2 0 100-4 2 2 0 000 4z">
                                            </path>
                                        </svg>
                                        Descargar Reporte
                                    </button>
                                    <button class="btn-secondary w-full">
                                        <svg class="w-4 h-4 inline-block mr-2" fill="currentColor" viewBox="0 0 20 20">
                                            <path fill-rule="evenodd"
                                                d="M4 2a1 1 0 011 1v2.101a7.002 7.002 0 0111.601 2.566 1 1 0 11-1.947.34A5.002 5.002 0 005.09 5.1A1 1 0 014 4.1V3a1 1 0 011-1zm.008 9a1 1 0 011.992 0 5 5 0 1019 0 1 1 0 11-2 0 3 3 0 10-6 0 1 1 0 01-1-1zm9-6a1 1 0 100-2 1 1 0 000 2z"
                                                clip-rule="evenodd"></path>
                                        </svg>
                                        Respaldar Base de Datos
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
</div>
</template>
<script setup></script>