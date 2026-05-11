<template>
    <div id="solicitudModal" class="modal active" @click.self="cerrar">
        <div class="modal-content w-full max-w-4xl mx-auto my-auto" @click.stop>
            <div class="bg-gray-50 px-8 py-6 border-b border-gray-200 flex items-center justify-between sticky top-0 z-10">
                <div>
                    <h2 class="text-2xl font-bold text-gray-800">
                        {{ uiState.editData ? 'Editar Solicitud' : 'Formulario de Solicitud (Completo)' }}
                    </h2>
                    <p class="text-gray-600 text-sm mt-1">
                        {{ uiState.editData ? `Editando registro: ${uiState.editData.comunicacion_interna || uiState.editData.id_solicitud}` : 'Llene los campos requeridos. Mantenga el formato simple tipo Excel.' }}
                    </p>
                </div>
                <button @click="cerrar" class="text-gray-500 hover:text-gray-700">
                    <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd"
                            d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                            clip-rule="evenodd"></path>
                    </svg>
                </button>
            </div>

            <div class="p-8 bg-white overflow-y-auto max-h-[70vh]">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">

                    <!-- Col 1: Datos de Ingreso -->
                    <div class="space-y-4">
                        <h3 class="font-black text-xs text-accent uppercase tracking-[0.2em] border-b pb-2">1. Información de Ingreso</h3>
                        
                        <div class="form-group">
                            <label>Comunicación Interna (Cod)</label>
                            <input type="text" v-model="form.comunicacion_interna" placeholder="Ej: 125/2026" class="form-input">
                        </div>

                        <div class="form-group">
                            <label>Fecha de Ingreso</label>
                            <input type="date" v-model="form.fecha_ingreso" class="form-input">
                        </div>

                        <div class="form-group">
                            <label>Nombre del Solicitante</label>
                            <input type="text" v-model="form.solicitante_nombre" @input="cap($event, 'solicitante_nombre')" placeholder="Nombre completo" class="form-input">
                        </div>

                        <div class="form-group">
                            <label>Teléfono Solicitante</label>
                            <input type="text" v-model="form.solicitante_telefono" placeholder="Celular o Fijo" class="form-input">
                        </div>
                    </div>

                    <!-- Col 2: Ubicación y Detalle -->
                    <div class="space-y-4">
                        <h3 class="font-black text-xs text-accent uppercase tracking-[0.2em] border-b pb-2">2. Ubicación del Árbol</h3>
                        
                        <div class="form-group">
                            <label>Distrito (Opcional)</label>
                            <select v-model="distritoSeleccionado" class="form-input">
                                <option :value="null">-- Seleccione Distrito --</option>
                                <option v-for="d in [1,2,3,4,5,6,7,8,9,10,11,12,13]" :key="d" :value="d">Distrito {{ d }}</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Barrio *</label>
                            <select v-model="form.id_barrio" class="form-input" required>
                                <option :value="null" disabled>-- Seleccione Barrio --</option>
                                <option v-for="b in barriosFiltrados" :key="b.id" :value="b.id">{{ b.nombre }}</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Calle / Avenida</label>
                            <input type="text" v-model="form.calle" @input="cap($event, 'calle')" placeholder="Nombre de calle" class="form-input">
                        </div>

                        <div class="flex gap-4">
                            <div class="form-group flex-1">
                                <label>Nº Casa</label>
                                <input type="text" v-model="form.numero_casa" placeholder="123" class="form-input">
                            </div>
                            <div class="form-group flex-[2]">
                                <label>Referencia</label>
                                <input type="text" v-model="form.referencia" @input="cap($event, 'referencia')" placeholder="Ej: Frente a la plaza" class="form-input">
                            </div>
                        </div>
                    </div>

                    <!-- Col 3: Lo Solicitado -->
                    <div class="space-y-4">
                        <h3 class="font-black text-xs text-accent uppercase tracking-[0.2em] border-b pb-2">3. Requerimiento</h3>

                        <div class="form-group">
                            <label>Acción Solicitada (Vecino)</label>
                            <select v-model="form.id_accion_solicitada" class="form-input">
                                <option :value="null">-- Seleccione --</option>
                                <option v-for="a in store.acciones" :key="a.id" :value="a.id">{{ a.nombre }}</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Descripción de lo Solicitado</label>
                            <textarea v-model="form.lo_solicitado" rows="3" class="form-input text-xs" placeholder="Lo que el vecino pide específicamente..."></textarea>
                        </div>

                        <div class="form-group">
                            <label>Nivel de Urgencia</label>
                            <div class="flex gap-2">
                                <button type="button" v-for="n in ['Baja', 'Intermedia', 'Alta']" :key="n"
                                    @click="form.nivel_urgencia = n"
                                    :class="['flex-1 py-2 rounded-xl text-[10px] font-black uppercase transition-all border', 
                                             form.nivel_urgencia === n ? 'bg-accent text-white border-accent' : 'bg-gray-100 text-gray-400 border-transparent']">
                                    {{ n }}
                                </button>
                            </div>
                        </div>

                        <div class="flex items-center gap-3 p-3 bg-red-50 rounded-xl border border-red-100">
                            <input type="checkbox" v-model="form.es_emergencia" id="chkEmerg" class="w-5 h-5 accent-red-600">
                            <label for="chkEmerg" class="text-xs font-black text-red-700 uppercase cursor-pointer">¿Es Emergencia?</label>
                        </div>
                    </div>

                    <!-- SECCIÓN TÉCNICA (SEGUNDA FILA) -->
                    <div class="md:col-span-2 lg:col-span-3 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 pt-6 border-t border-dashed border-gray-200">
                        
                        <!-- Col 4: Verificación -->
                        <div class="space-y-4">
                            <h3 class="font-black text-xs text-blue-600 uppercase tracking-[0.2em] border-b pb-2">4. Informe Técnico</h3>
                            
                            <div class="form-group">
                                <label>Técnico que Verificó</label>
                                <select v-model="form.id_tecnico_verificacion" class="form-input">
                                    <option :value="null">-- Seleccione Técnico --</option>
                                    <option v-for="t in store.tecnicos" :key="t.id" :value="t.id">{{ t.nombre }}</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Fecha Verificación</label>
                                <input type="date" v-model="form.fecha_verificacion" class="form-input">
                            </div>

                            <div class="form-group">
                                <label>Acción Determinada (Oficina)</label>
                                <select v-model="form.id_accion" class="form-input">
                                    <option :value="null">-- Seleccione Acción Final --</option>
                                    <option v-for="a in store.acciones" :key="a.id" :value="a.id">{{ a.nombre }}</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Especie Forestal</label>
                                <select v-model="form.id_especie" class="form-input">
                                    <option :value="null">-- Seleccione Especie --</option>
                                    <option v-for="e in store.especies" :key="e.id" :value="e.id">{{ e.nombre }}</option>
                                </select>
                            </div>
                        </div>

                        <!-- Col 5: Requerimientos Logísticos -->
                        <div class="space-y-4">
                            <h3 class="font-black text-xs text-amber-600 uppercase tracking-[0.2em] border-b pb-2">5. Logística y Decisión</h3>
                            
                            <div class="grid grid-cols-2 gap-3">
                                <div class="flex items-center gap-2 p-3 bg-gray-50 rounded-xl border border-gray-200">
                                    <input type="checkbox" v-model="form.procede" id="chkProcede" class="accent-green-600">
                                    <label for="chkProcede" class="text-[10px] font-bold uppercase">¿Procede?</label>
                                </div>
                                <div class="flex items-center gap-2 p-3 bg-gray-50 rounded-xl border border-gray-200">
                                    <input type="checkbox" v-model="form.arbol_seco" id="chkSeco" class="accent-amber-600">
                                    <label for="chkSeco" class="text-[10px] font-bold uppercase">Arbol Seco</label>
                                </div>
                                <div class="flex items-center gap-2 p-3 bg-gray-50 rounded-xl border border-gray-200">
                                    <input type="checkbox" v-model="form.requiere_plataforma" id="chkPlat" class="accent-blue-600">
                                    <label for="chkPlat" class="text-[10px] font-bold uppercase">Grúa/Plat</label>
                                </div>
                                <div class="flex items-center gap-2 p-3 bg-gray-50 rounded-xl border border-gray-200">
                                    <input type="checkbox" v-model="form.requiere_setar" id="chkSetar" class="accent-orange-600">
                                    <label for="chkSetar" class="text-[10px] font-bold uppercase">SETAR</label>
                                </div>
                                <div class="flex items-center gap-2 p-3 bg-gray-50 rounded-xl border border-gray-200">
                                    <input type="checkbox" v-model="form.requiere_ficha_tecnica" id="chkFicha" class="accent-purple-600">
                                    <label for="chkFicha" class="text-[10px] font-bold uppercase">Ficha Téc.</label>
                                </div>
                                <div class="form-group">
                                    <label class="text-[9px]">Cant Notas</label>
                                    <input type="number" v-model="form.cantidad_notas" class="form-input py-1.5">
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Observación de Verificación</label>
                                <textarea v-model="form.observacion_verificacion" rows="2" class="form-input text-xs" placeholder="Notas adicionales del técnico..."></textarea>
                            </div>
                        </div>

                        <!-- Col 6: Ejecución y Cierre -->
                        <div class="space-y-4">
                            <h3 class="font-black text-xs text-green-600 uppercase tracking-[0.2em] border-b pb-2">6. Ejecución y Cierre</h3>
                            
                            <div class="form-group">
                                <label>Estado del Trámite</label>
                                <select v-model="form.estado_tramite" class="form-input font-black uppercase text-accent">
                                    <option value="En espera">🟡 En espera</option>
                                    <option value="En proceso">🔵 En proceso</option>
                                    <option value="Terminado">🟢 Terminado</option>
                                    <option value="Anulado">🔴 Anulado</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Técnico que Ejecutó</label>
                                <select v-model="form.id_tecnico_ejecucion" class="form-input">
                                    <option :value="null">-- Seleccione Técnico --</option>
                                    <option v-for="t in store.tecnicos" :key="t.id" :value="t.id">{{ t.nombre }}</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Fecha de Ejecución</label>
                                <input type="date" v-model="form.fecha_ejecucion" class="form-input">
                            </div>

                            <div class="form-group">
                                <label>Observaciones de Cierre</label>
                                <textarea v-model="form.observaciones_finales" rows="2" class="form-input text-xs" placeholder="Resumen del trabajo realizado..."></textarea>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

            <div class="bg-gray-50 px-8 py-6 border-t border-gray-200 flex justify-end gap-3 rounded-b-3xl">
                <button @click="cerrar" class="px-6 py-3 text-sm font-bold text-gray-500 hover:bg-gray-100 rounded-2xl transition-all">
                    Cancelar
                </button>
                <button @click="guardarSolicitud" class="px-10 py-3 bg-accent text-white font-black rounded-2xl shadow-lg shadow-accent/20 hover:scale-[1.02] active:scale-[0.98] transition-all">
                    {{ uiState.editData ? 'GUARDAR CAMBIOS' : 'REGISTRAR SOLICITUD' }}
                </button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { store, uiState, addSolicitud, updateSolicitud, showToast } from '../store/data.js'

const emit = defineEmits(['close'])

const cap = (e, field) => {
    const v = e.target.value
    if (v && v[0] !== v[0].toUpperCase()) {
        form.value[field] = v[0].toUpperCase() + v.slice(1)
    } else {
        form.value[field] = v
    }
}

const distritoSeleccionado = ref(null)
const tipoInstitucionSeleccionado = ref(null)

const barriosFiltrados = computed(() => {
    if (!distritoSeleccionado.value) return store.barrios;
    return store.barrios.filter(b => b.id_distrito === distritoSeleccionado.value);
})

const hoy = new Date().toISOString().split('T')[0]

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

// Cargar datos si es edición
onMounted(() => {
    if (uiState.editData) {
        // Clonar datos para evitar modificar el store directamente por referencia reactiva
        Object.keys(form.value).forEach(key => {
            if (uiState.editData[key] !== undefined) {
                // Formatear fechas para los inputs type="date" (YYYY-MM-DD)
                if (key.startsWith('fecha_') && uiState.editData[key]) {
                    form.value[key] = new Date(uiState.editData[key]).toISOString().split('T')[0]
                } else {
                    form.value[key] = uiState.editData[key]
                }
            }
        })
    }
})

const cerrar = () => {
    uiState.editData = null
    emit('close')
}

const guardarSolicitud = async () => {
    let exito = false
    if (uiState.editData) {
        exito = await updateSolicitud(uiState.editData.id_solicitud, { ...form.value })
        if (exito) showToast('Registro actualizado correctamente.', 'success')
    } else {
        exito = await addSolicitud({ ...form.value })
        if (exito) showToast('Nueva solicitud registrada correctamente.', 'success')
    }

    if (exito) cerrar()
    else showToast('No se pudo guardar. Revisa la conexión.', 'error')
}

watch(() => form.value.id_barrio, (newVal) => {
    if (newVal) {
        const barrio = store.barrios.find(b => b.id === newVal);
        if (barrio && barrio.id_distrito) distritoSeleccionado.value = barrio.id_distrito;
    }
})
</script>

<style scoped>
.modal {
    position: fixed; top: 0; left: 0; width: 100%; height: 100%;
    background-color: rgba(0,0,0,0.6); display: flex;
    justify-content: center; align-items: center; z-index: 100;
    backdrop-filter: blur(4px);
}
.modal-content {
    background: white; border-radius: 2.5rem;
    box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5);
    overflow: hidden; animation: modalIn 0.3s cubic-bezier(0.34,1.56,0.64,1);
}
@keyframes modalIn { from { opacity: 0; transform: scale(0.9) translateY(20px); } to { opacity: 1; transform: scale(1) translateY(0); } }

.form-group { @apply flex flex-col gap-1; }
.form-group label { @apply text-[10px] font-black text-gray-400 uppercase tracking-widest ml-1; }
.form-input { 
    @apply px-4 py-3 bg-gray-50 border-2 border-gray-100 rounded-2xl text-sm font-bold text-gray-800 outline-none transition-all;
    @apply focus:border-accent focus:bg-white focus:ring-4 focus:ring-accent/5;
}
</style>