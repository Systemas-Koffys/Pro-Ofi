<template>
    <div id="solicitudModal" class="modal active" @click.self="$emit('close')">
        <div class="modal-content w-full max-w-4xl mx-auto my-auto" @click.stop>
            <div class="bg-gray-50 px-8 py-6 border-b border-gray-200 flex items-center justify-between sticky top-0 z-10">
                <div>
                    <h2 class="text-2xl font-bold text-gray-800">
                        Formulario de Solicitud (Completo)
                    </h2>
                    <p class="text-gray-600 text-sm mt-1">
                        Llene los campos requeridos. Mantenga el formato simple tipo Excel.
                    </p>
                </div>
                <button @click="$emit('close')" class="text-gray-500 hover:text-gray-700">
                    <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd"
                            d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                            clip-rule="evenodd"></path>
                    </svg>
                </button>
            </div>

            <div class="p-8 max-h-[calc(90vh-140px)] overflow-y-auto">
                <form @submit.prevent="guardarSolicitud">
                    
                    <!-- 1. Fechas y Comunicación Interna -->
                    <div class="form-section mb-6 p-4 border border-gray-200 rounded-lg bg-white">
                        <h3 class="text-lg font-semibold text-gray-700 mb-4 border-b pb-2">1. Registro Inicial</h3>
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Comunicación Interna (Cod)</label>
                                <input type="text" v-model="form.comunicacion_interna" placeholder="Ej. Cod 0001/24" required class="w-full border rounded p-2" />
                            </div>
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Fecha de Ingreso</label>
                                <input type="date" v-model="form.fecha_ingreso" required class="w-full border rounded p-2" />
                            </div>
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Fecha de Verificación</label>
                                <input type="date" v-model="form.fecha_verificacion" class="w-full border rounded p-2" />
                            </div>
                        </div>
                    </div>

                    <!-- 2. Solicitante y Pedido -->
                    <div class="form-section mb-6 p-4 border border-gray-200 rounded-lg bg-white">
                        <h3 class="text-lg font-semibold text-gray-700 mb-4 border-b pb-2">2. Datos del Solicitante y Pedido</h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Nombre Solicitante</label>
                                <input type="text" v-model="form.solicitante_nombre" placeholder="Nombre completo" required class="w-full border rounded p-2" />
                            </div>
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Teléfono / Celular</label>
                                <input type="tel" v-model="form.solicitante_telefono" placeholder="Número" required class="w-full border rounded p-2" />
                            </div>
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Transcripción de la Nota (Texto Libre)</label>
                                <textarea v-model="form.lo_solicitado" placeholder="Lo que piden literalmente..." rows="2" class="w-full border rounded p-2" required></textarea>
                            </div>
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Lo Solicitado (Categoría)</label>
                                <select v-model="form.id_accion_solicitada" class="w-full border rounded p-2">
                                    <option :value="null">-- Seleccionar --</option>
                                    <option v-for="a in store.acciones" :key="a.id" :value="a.id" :title="a.nombre" class="truncate">{{ a.nombre }}</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- 3. Ubicación -->
                    <div class="form-section mb-6 p-4 border border-gray-200 rounded-lg bg-white">
                        <h3 class="text-lg font-semibold text-gray-700 mb-4 border-b pb-2">3. Ubicación de la Poda</h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <!-- Distritos y Barrios -->
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Distrito (Opcional ayuda)</label>
                                <select v-model="distritoSeleccionado" class="w-full border rounded p-2">
                                    <option :value="null">-- Seleccionar Distrito --</option>
                                    <option v-for="dist in store.distritos" :key="dist.id" :value="dist.id">
                                        {{ dist.nombre }}
                                    </option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Barrio (Obligatorio si no hay Institución)</label>
                                <select v-model="form.id_barrio" class="w-full border rounded p-2">
                                    <option :value="null">-- Seleccionar Barrio --</option>
                                    <option v-for="barrio in barriosFiltrados" :key="barrio.id" :value="barrio.id">
                                        {{ barrio.nombre }}
                                    </option>
                                </select>
                            </div>

                            <!-- Instituciones -->
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Tipo de Institución (Opcional)</label>
                                <select v-model="tipoInstitucionSeleccionado" class="w-full border rounded p-2">
                                    <option :value="null">-- Seleccionar Tipo --</option>
                                    <option v-for="tipo in store.tipos_institucion" :key="tipo.id" :value="tipo.id">
                                        {{ tipo.nombre }}
                                    </option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Institución</label>
                                <select v-model="form.id_nombre_institucional" class="w-full border rounded p-2">
                                    <option :value="null">-- Ninguna Institución --</option>
                                    <option v-for="inst in institucionesFiltradas" :key="inst.id" :value="inst.id">
                                        {{ inst.nombre }}
                                    </option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Calle</label>
                                <input type="text" v-model="form.calle" placeholder="Nombre de calle" class="w-full border rounded p-2" />
                            </div>
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Número de Casa</label>
                                <input type="text" v-model="form.numero_casa" placeholder="S/N" class="w-full border rounded p-2" />
                            </div>
                            <div class="form-group md:col-span-2">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Referencia</label>
                                <input type="text" v-model="form.referencia" placeholder="Frente a la plaza, puerta azul..." class="w-full border rounded p-2" />
                            </div>
                        </div>
                    </div>

                    <!-- 4. Verificación Técnica -->
                    <div class="form-section mb-6 p-4 border border-gray-200 rounded-lg bg-blue-50">
                        <h3 class="text-lg font-semibold text-blue-800 mb-4 border-b border-blue-200 pb-2">4. Verificación Técnica</h3>
                        
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Técnico de Verificación</label>
                                <select v-model="form.id_tecnico_verificacion" class="w-full border rounded p-2">
                                    <option :value="null">-- Seleccionar --</option>
                                    <option v-for="t in store.tecnicos" :key="t.id" :value="t.id">{{ t.nombre }}</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Especie de Árbol</label>
                                <select v-model="form.id_especie" class="w-full border rounded p-2">
                                    <option :value="null">-- Seleccionar --</option>
                                    <option v-for="e in store.especies" :key="e.id" :value="e.id">{{ e.nombre }}</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Acción Determinada (Técnico)</label>
                                <select v-model="form.id_accion" class="w-full border rounded p-2">
                                    <option :value="null">-- Seleccionar --</option>
                                    <option v-for="a in store.acciones" :key="a.id" :value="a.id" :title="a.nombre" class="truncate">{{ a.nombre }}</option>
                                </select>
                            </div>
                        </div>

                        <!-- Checkboxes Técnicos -->
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 bg-white p-4 rounded border">
                            <label class="flex items-center space-x-2">
                                <input type="checkbox" v-model="form.requiere_plataforma" class="rounded text-blue-600" />
                                <span class="text-sm">Req. Plataforma</span>
                            </label>
                            <label class="flex items-center space-x-2">
                                <input type="checkbox" v-model="form.requiere_setar" class="rounded text-blue-600" />
                                <span class="text-sm">Req. SETAR</span>
                            </label>
                            <label class="flex items-center space-x-2">
                                <input type="checkbox" v-model="form.requiere_ficha_tecnica" class="rounded text-blue-600" />
                                <span class="text-sm">Req. Ficha Técnica</span>
                            </label>
                            <label class="flex items-center space-x-2">
                                <input type="checkbox" v-model="form.arbol_seco" class="rounded text-blue-600" />
                                <span class="text-sm">Árbol Seco</span>
                            </label>
                            <label class="flex items-center space-x-2 text-green-700 font-bold">
                                <input type="checkbox" v-model="form.procede" class="rounded text-green-600" />
                                <span class="text-sm">¿Procede Trabajo?</span>
                            </label>
                            <label class="flex items-center space-x-2 text-red-700 font-bold">
                                <input type="checkbox" v-model="form.es_emergencia" class="rounded text-red-600" />
                                <span class="text-sm">ES EMERGENCIA</span>
                            </label>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Cantidad de Notas</label>
                                <input type="number" v-model="form.cantidad_notas" min="1" class="w-full border rounded p-2" />
                            </div>
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Nivel de Urgencia</label>
                                <select v-model="form.nivel_urgencia" class="w-full border rounded p-2">
                                    <option value="Baja">Baja</option>
                                    <option value="Intermedia">Intermedia</option>
                                    <option value="Alta">Alta</option>
                                </select>
                            </div>
                            <div class="form-group md:col-span-2">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Observación de Verificación</label>
                                <textarea v-model="form.observacion_verificacion" placeholder="Comentarios tras inspección técnica..." rows="2" class="w-full border rounded p-2"></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- 5. Ejecución Final -->
                    <div class="form-section mb-6 p-4 border border-gray-200 rounded-lg bg-green-50">
                        <h3 class="text-lg font-semibold text-green-800 mb-4 border-b border-green-200 pb-2">5. Ejecución y Cierre</h3>
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Técnico de Ejecución</label>
                                <select v-model="form.id_tecnico_ejecucion" class="w-full border rounded p-2">
                                    <option :value="null">-- Pendiente --</option>
                                    <option v-for="t in store.tecnicos" :key="t.id" :value="t.id">{{ t.nombre }}</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Fecha de Ejecución</label>
                                <input type="date" v-model="form.fecha_ejecucion" class="w-full border rounded p-2" />
                            </div>
                            <div class="form-group">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Estado Trámite</label>
                                <select v-model="form.estado_tramite" class="w-full border rounded p-2 font-bold text-gray-800">
                                    <option value="En espera">En espera</option>
                                    <option value="Terminado">Terminado</option>
                                </select>
                            </div>
                            <div class="form-group md:col-span-3">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Observaciones Finales</label>
                                <textarea v-model="form.observaciones_finales" placeholder="Comentarios tras finalizar el trabajo..." rows="2" class="w-full border rounded p-2"></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <div class="flex gap-3 justify-end mt-8 pt-6 border-t border-gray-200">
                        <button type="button" class="px-6 py-2 border border-gray-300 rounded text-gray-700 hover:bg-gray-100" @click="$emit('close')">
                            Cancelar
                        </button>
                        <button type="submit" class="px-6 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 font-bold">
                            Guardar Toda la Solicitud
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { store, addSolicitud } from '../store/data.js'

const emit = defineEmits(['close'])

const distritoSeleccionado = ref(null)
const tipoInstitucionSeleccionado = ref(null)

// Computed para filtrar barrios según el distrito si lo seleccionó
const barriosFiltrados = computed(() => {
    if (!distritoSeleccionado.value) {
        return store.barrios; // Mostrar todos si no seleccionó distrito
    }
    return store.barrios.filter(b => b.id_distrito === distritoSeleccionado.value);
})

// Computed para filtrar instituciones según el tipo seleccionado
const institucionesFiltradas = computed(() => {
    if (!tipoInstitucionSeleccionado.value) {
        return store.instituciones; // Mostrar todas si no seleccionó tipo
    }
    return store.instituciones.filter(i => i.id_tipo === tipoInstitucionSeleccionado.value);
})

const hoy = new Date().toISOString().split('T')[0]

// Objeto que coincide con la BD
const form = ref({
    comunicacion_interna: '',
    fecha_ingreso: hoy,
    fecha_verificacion: '',
    id_barrio: null,
    id_nombre_institucional: null,
    id_accion: null,
    id_especie: null,
    calle: '',
    numero_casa: '',
    referencia: '',
    solicitante_nombre: '',
    solicitante_telefono: '',
    lo_solicitado: '',
    id_accion_solicitada: null,
    id_tecnico_verificacion: null,
    requiere_plataforma: false,
    requiere_setar: false,
    requiere_ficha_tecnica: false,
    procede: false,
    cantidad_notas: 1,
    arbol_seco: false,
    es_emergencia: false,
    nivel_urgencia: 'Baja',
    observacion_verificacion: '',
    id_tecnico_ejecucion: null,
    fecha_ejecucion: '',
    observaciones_finales: '',
    estado_tramite: 'En espera'
})

const guardarSolicitud = () => {
    // Básica validación
    if (!form.value.id_barrio && !form.value.id_nombre_institucional) {
        alert("Atención: Debes seleccionar al menos un Barrio o una Institución.");
        return;
    }
    
    // Convert reactive object to raw object
    addSolicitud({ ...form.value })
    alert("¡Solicitud guardada en el simulador!")
    emit('close')
}
</script>

<style scoped>
.modal {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0,0,0,0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 50;
}
</style>