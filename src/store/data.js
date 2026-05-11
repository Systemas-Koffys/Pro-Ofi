import { reactive } from 'vue';

export const uiState = reactive({
  showModal: false,
  editData: null,
  theme: 'colors',
  user: JSON.parse(localStorage.getItem('user')) || null,
  loginTime: localStorage.getItem('loginTime') || null,
  logo_app: localStorage.getItem('logo_app') || null,
  logo_institucional: localStorage.getItem('logo_institucional') || null
});

// --- Sistema de Notificaciones (Toast) ---
export const toast = reactive({
  visible: false,
  message: '',
  type: 'success'   // 'success' | 'error'
});

let _toastTimer = null;
export function showToast(message, type = 'success', durationMs = 3500) {
  if (_toastTimer) clearTimeout(_toastTimer);
  toast.message = message;
  toast.type = type;
  toast.visible = true;
  _toastTimer = setTimeout(() => { toast.visible = false; }, durationMs);
}

// --- Sistema de Autenticación ---
export async function login(username, password) {
  try {
    const response = await fetch(`${API_URL}/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password })
    });
    const data = await response.json();
    if (data.success) {
      uiState.user = data.user;
      const now = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
      uiState.loginTime = now;
      localStorage.setItem('user', JSON.stringify(data.user));
      localStorage.setItem('loginTime', now);
      localStorage.setItem('loginTimeFull', new Date().toISOString());
      return true;
    }
    return false;
  } catch (error) {
    console.error('Error en login:', error);
    return false;
  }
}

export function logout() {
  uiState.user = null;
  uiState.loginTime = null;
  localStorage.removeItem('user');
  localStorage.removeItem('loginTime');
}

// -----------------------------------------

// Estado global para los catálogos y solicitudes
export const store = reactive({
  tecnicos: [],
  acciones: [],
  especies: [],
  tipos_institucion: [],
  instituciones: [],
  distritos: [],
  barrios: [],
  solicitudes: [],
  usuarios: [],
  impresiones: [],
  config: {}
});

// URL del backend (ahora manejada por el proxy de Vite en el puerto 5173)
const API_URL = '/api';


// Función para descargar los catálogos de MySQL
export async function fetchCatalogos() {
  try {
    const response = await fetch(`${API_URL}/catalogos`);
    const data = await response.json();
    
    // Poblar el store
    store.tecnicos = data.tecnicos || [];
    store.acciones = data.acciones || [];
    store.especies = data.especies || [];
    store.tipos_institucion = data.tipos_institucion || [];
    store.instituciones = data.instituciones || [];
    store.distritos = data.distritos || [];
    store.barrios = data.barrios || [];
    
    // También descargamos usuarios, impresiones y configuración
    try { await fetchUsuarios(); } catch(e) { console.error(e); }
    try { await fetchImpresiones(); } catch(e) { console.error(e); }
    try { await fetchConfig(); } catch(e) { console.error(e); }
    
    console.log("Catálogos cargados desde MySQL con éxito.");
  } catch (error) {
    console.error("Error al cargar los catálogos:", error);
  }
}

// --- CONFIGURACIÓN DEL SISTEMA ---
export async function fetchConfig() {
  try {
    const response = await fetch(`${API_URL}/config`);
    store.config = await response.json();
  } catch (error) {
    console.error("Error al cargar configuración:", error);
  }
}

export async function updateConfig(datos) {
  try {
    const response = await fetch(`${API_URL}/config`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(datos)
    });
    if (response.ok) {
      await fetchConfig();
      return true;
    }
    return false;
  } catch (error) {
    console.error("Error al actualizar configuración:", error);
    return false;
  }
}

// Función para descargar historial de impresiones
export async function fetchImpresiones() {
  try {
    const response = await fetch(`${API_URL}/impresiones`);
    store.impresiones = await response.json();
  } catch (error) {
    console.error("Error al cargar impresiones:", error);
  }
}

// Función para registrar una impresión
export async function registrarImpresion(id_solicitud, tipo_reporte, detalles = null) {
  try {
    const response = await fetch(`${API_URL}/impresiones`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        id_solicitud,
        tipo_reporte,
        usuario: uiState.user?.nombre || 'Desconocido',
        detalles
      })
    });
    if (response.ok) {
      await fetchImpresiones();
      return true;
    }
    return false;
  } catch (error) {
    console.error("Error al registrar impresión:", error);
    return false;
  }
}

// Función para descargar los usuarios públicos (para el login)
export async function fetchPublicUsuarios() {
  try {
    const response = await fetch(`${API_URL}/usuarios/publico`);


    return await response.json();
  } catch (error) {
    console.error("Error al cargar usuarios públicos:", error);
    return [];
  }
}

// Función para descargar los usuarios de MySQL
export async function fetchUsuarios() {

  try {
    const response = await fetch(`${API_URL}/usuarios`);
    store.usuarios = await response.json();
    console.log("Usuarios cargados desde MySQL con éxito.");
  } catch (error) {
    console.error("Error al cargar los usuarios:", error);
  }
}

// Función para guardar un nuevo usuario
export async function addUsuario(usuario) {
  try {
    const response = await fetch(`${API_URL}/usuarios`, {
      method: 'POST',
      headers: { 
        'Content-Type': 'application/json',
        'X-User-Role': uiState.user?.role
      },
      body: JSON.stringify(usuario)
    });
    if (response.ok) {
      await fetchUsuarios();
      return true;
    }
    const err = await response.json();
    return err.error || 'Error en el servidor';
  } catch (error) {
    console.error('Error al agregar usuario:', error);
    return false;
  }
}

// Función para eliminar un usuario
export async function deleteUsuario(id) {
  try {
    const response = await fetch(`${API_URL}/usuarios/${id}`, {
      method: 'DELETE',
      headers: { 'X-User-Role': uiState.user?.role }
    });
    if (response.ok) {
      store.usuarios = store.usuarios.filter(u => u.id != id);
      return true;
    }
    return false;
  } catch (error) {
    console.error('Error al eliminar usuario:', error);
    return false;
  }
}

// Función para actualizar un usuario
export async function updateUsuario(id, usuario) {
  try {
    const response = await fetch(`${API_URL}/usuarios/${id}`, {
      method: 'PUT',
      headers: { 
        'Content-Type': 'application/json',
        'X-User-Role': uiState.user?.role
      },
      body: JSON.stringify(usuario)
    });
    if (response.ok) {
      await fetchUsuarios();
      return true;
    }
    const err = await response.json();
    return err.error || 'Error en el servidor';
  } catch (error) {
    console.error('Error al actualizar usuario:', error);
    return false;
  }
}

// Función para descargar las solicitudes de MySQL
export async function fetchSolicitudes() {
  try {
    const response = await fetch(`${API_URL}/solicitudes`);
    store.solicitudes = await response.json();
    console.log("Solicitudes cargadas desde MySQL con éxito.");
  } catch (error) {
    console.error("Error al cargar las solicitudes:", error);
  }
}

// Función para guardar una nueva solicitud en MySQL
export async function addSolicitud(solicitud) {
  try {
    const response = await fetch(`${API_URL}/solicitudes`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(solicitud)
    });
    
    const data = await response.json();
    
    if (response.ok) {
      // Le agregamos el ID que nos devolvió MySQL y la metemos al store local para actualizar la tabla visual
      solicitud.id_solicitud = data.id_solicitud;
      store.solicitudes.push(solicitud);
      return true;
    } else {
      console.error("Error del servidor:", data.error);
      return false;
    }
  } catch (error) {
    console.error("Error de red al guardar la solicitud:", error);
    return false;
  }
}

// Función para ELIMINAR una solicitud de MySQL
export async function deleteSolicitud(id) {
  try {
    const response = await fetch(`${API_URL}/solicitudes/${id}`, {
      method: 'DELETE'
    });
    if (response.ok) {
      store.solicitudes = store.solicitudes.filter(s => s.id_solicitud != id);
      return true;
    }
    return false;
  } catch (error) {
    console.error('Error al eliminar:', error);
    return false;
  }
}

// Función para ACTUALIZAR una solicitud en MySQL
export async function updateSolicitud(id, datos) {
  try {
    const response = await fetch(`${API_URL}/solicitudes/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(datos)
    });
    if (response.ok) {
      const idx = store.solicitudes.findIndex(s => s.id_solicitud == id);
      if (idx !== -1) store.solicitudes[idx] = { ...store.solicitudes[idx], ...datos, id_solicitud: id };
      return true;
    }
    return false;
  } catch (error) {
    console.error('Error al actualizar:', error);
    return false;
  }
}
// --- GESTIÓN DE CATÁLOGOS (DINÁMICO) ---
export async function addCatalogo(tabla, datos) {
  try {
    const response = await fetch(`${API_URL}/catalogos/${tabla}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(datos)
    });
    if (response.ok) {
      await fetchCatalogos(); // Recargar todo para sincronizar
      return true;
    }
    return false;
  } catch (error) {
    console.error(`Error al agregar en ${tabla}:`, error);
    return false;
  }
}

export async function updateCatalogo(tabla, id, datos) {
  try {
    const response = await fetch(`${API_URL}/catalogos/${tabla}/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(datos)
    });
    if (response.ok) {
      await fetchCatalogos();
      return true;
    }
    return false;
  } catch (error) {
    console.error(`Error al actualizar en ${tabla}:`, error);
    return false;
  }
}

export async function deleteCatalogo(tabla, id) {
  try {
    const response = await fetch(`${API_URL}/catalogos/${tabla}/${id}`, {
      method: 'DELETE'
    });
    if (response.ok) {
      await fetchCatalogos();
      return true;
    }
    return false;
  } catch (error) {
    console.error(`Error al eliminar de ${tabla}:`, error);
    return false;
  }
}
