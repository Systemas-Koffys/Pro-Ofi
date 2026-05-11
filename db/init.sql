-- Inicialización de Base de Datos para dboficina
-- Codificación: UTF-8 (utf8mb4) para español: ñ, acentos, etc.

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

CREATE DATABASE IF NOT EXISTS dboficina CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE dboficina;

CREATE TABLE tipos_institucion (
    id INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);
INSERT INTO tipos_institucion (id, nombre) VALUES (1, "Área Rural");
INSERT INTO tipos_institucion (id, nombre) VALUES (2, "Salud y Hospitales");
INSERT INTO tipos_institucion (id, nombre) VALUES (3, "Educación");
INSERT INTO tipos_institucion (id, nombre) VALUES (4, "Organización Social");
INSERT INTO tipos_institucion (id, nombre) VALUES (5, "Entidad Municipal");
INSERT INTO tipos_institucion (id, nombre) VALUES (6, "Institución u Organización");

CREATE TABLE distritos (
    id INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);
INSERT INTO distritos (id, nombre) VALUES (1, "Distrito 1");
INSERT INTO distritos (id, nombre) VALUES (2, "Distrito 2");
INSERT INTO distritos (id, nombre) VALUES (3, "Distrito 3");
INSERT INTO distritos (id, nombre) VALUES (4, "Distrito 4");
INSERT INTO distritos (id, nombre) VALUES (5, "Distrito 5");
INSERT INTO distritos (id, nombre) VALUES (6, "Distrito 6");
INSERT INTO distritos (id, nombre) VALUES (7, "Distrito 7");
INSERT INTO distritos (id, nombre) VALUES (8, "Distrito 8");
INSERT INTO distritos (id, nombre) VALUES (9, "Distrito 9");
INSERT INTO distritos (id, nombre) VALUES (10, "Distrito 10");
INSERT INTO distritos (id, nombre) VALUES (11, "Distrito 11");
INSERT INTO distritos (id, nombre) VALUES (12, "Distrito 12");
INSERT INTO distritos (id, nombre) VALUES (13, "Distrito 13");

CREATE TABLE barrios (
    id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_distrito INT,
    FOREIGN KEY (id_distrito) REFERENCES distritos(id)
);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (1, "EL MOLINO", 1);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (2, "SAN ROQUE", 2);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (3, "LAS PANOSAS", 3);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (4, "LA PAMPA", 4);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (5, "VIRGEN DE FATIMA", 5);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (6, "LA LOMA", 6);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (7, "EL CARMEN", 6);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (8, "GUADALQUIVIR", 6);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (9, "57 VIVIENDAS", 6);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (10, "LUIS PIZARRO", 6);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (11, "15 DE NOVIEMBRE", 6);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (12, "JUAN PABLO II", 6);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (13, "VIRGEN DE CHAGUAYA", 6);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (14, "LIBERTAD", 6);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (15, "PANAMERICANO", 6);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (16, "15 DE AGOSTO", 6);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (17, "LA TORRE", 6);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (18, "LA UNION", 6);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (19, "CARLOS WAGNNER", 6);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (20, "PARAISO", 6);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (21, "LOS ALAMOS", 6);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (22, "LOS OLIVOS", 6);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (23, "4 DE JULIO", 7);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (24, "12 DE OCTUBRE", 7);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (25, "IV CENTENARIO", 7);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (26, "DEFENSORES DEL CHACO", 7);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (27, "LAS PASCUAS", 7);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (28, "3 DE MAYO", 7);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (29, "LOS CHAPACOS", 7);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (30, "MARIA DE LOS ANGELES", 7);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (31, "15 DE JUNIO", 7);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (32, "MUNICIPAL", 7);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (33, "19 DE MARZO", 7);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (34, "20 DE ENERO", 7);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (35, "101 FAMILIAS", 7);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (36, "NUEVA ESPERANZA", 7);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (37, "EDUARDO AVAROA", 8);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (38, "OSCAR ALFARO", 8);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (39, "SAN JOSE", 8);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (40, "SAN MARCOS", 8);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (41, "LOURDES", 8);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (42, "LA FLORIDA", 8);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (43, "PASCUAS", 8);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (44, "LOS LAURELES", 8);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (45, "LA HUERTA", 8);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (46, "6 DE AGOSTO", 9);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (47, "SALAMANCA", 9);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (48, "SAN BERNARDO", 9);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (49, "ANDALUZ", 9);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (50, "02 DE MAYO", 9);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (51, "PEDRO ANTONIO FLORES", 9);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (52, "CONSTRUCTOR", 9);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (53, "24 DE JUNIO", 9);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (54, "ANICETO ARCE", 9);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (55, "NARCISO CAMPERO", 9);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (56, "LUIS ESPINAL", 9);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (57, "7 DE SEPTIMBRE", 9);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (58, "BARTOLOME ATARD", 9);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (59, "MOTO MENDEZ", 9);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (60, "JUAN XXIII", 10);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (61, "ROSEDAL", 10);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (62, "JUAN NICOLAY", 10);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (63, "15 DE ABRIL", 10);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (64, "AEROPUERTO", 10);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (65, "MORROS BLANCOS", 10);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (66, "SAN PEDRO", 10);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (67, "SAN JORGE 1", 10);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (68, "SAN SALVADOR", 10);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (69, "SAN JORGE 2", 10);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (70, "ARTESANAL", 10);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (71, "LINDO SAN GERONIMO", 11);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (72, "SAN GERONIMO CENTRO", 11);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (73, "SAN GERONIMO SUD", 11);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (74, "SAN LUIS", 11);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (75, "LA TERMINAL", 11);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (76, "PETROLERO", 11);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (77, "EL TEJAR", 11);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (78, "MIRAFLORES", 12);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (79, "GERMAN BUSCH", 12);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (80, "ARANJUEZ SUD", 12);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (81, "SAN MARTIN", 12);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (82, "LUIS DE FUENTES", 13);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (83, "CATEDRAL", 13);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (84, "SAN ANTONIO", 13);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (85, "SAN BLAS", 13);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (86, "ALTO SENAC", 13);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (87, "SENAC", 13);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (88, "TABLADITA I", 13);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (89, "TABLADITA II", 13);
INSERT INTO barrios (id, nombre, id_distrito) VALUES (90, "MENDEZ ARCOS", 13);

CREATE TABLE instituciones (
    id INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    id_tipo INT,
    id_distrito INT,
    FOREIGN KEY (id_tipo) REFERENCES tipos_institucion(id),
    FOREIGN KEY (id_distrito) REFERENCES distritos(id)
);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (1, "BELLA VISTA", 1, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (2, "CHURQUIS", NULL, 1);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (3, "GUERRAHUAYCO", 1, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (4, "LA PINTADA", 1, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (5, "LAZARETO", 1, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (6, "MONTE CERCADO", 1, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (7, "PAMPA REDONDA", 1, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (8, "POLLA", 1, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (9, "SAN AGUSTIN", 1, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (10, "SAN JACINTO", 1, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (11, "SAN MATEO", 1, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (12, "SAN PEDRO DE SOLA", 1, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (13, "SANTA ANA LA NUEVA", 1, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (14, "SELLA CERCADO", 1, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (15, "TOLOMOSA GRANDE", 1, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (16, "TOLOMOSITA", 1, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (17, "TURUMAYO", 1, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (18, "YESERA", 1, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (19, "C.S. 15 DE NOVIEMBRE", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (20, "C.S. 3 DE MAYO", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (21, "C.S. ARANJUEZ SUD", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (22, "C.S. CONSTRUCTOR", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (23, "C.S. FABRIL", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (24, "C.S. GERMAN BUSCH", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (25, "C.S. GUADALQUIVIR", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (26, "C.S. IV. CENTENARIO", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (27, "C.S. NESTOR PAZ", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (28, "C.S. PALMARCITO", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (29, "C.S. SAN ANTONIO", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (30, "C.S. SAN BLAS", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (31, "C.S. SAN JORGE", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (32, "C.S. SAN LUIS", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (33, "C.S. TABLADITA", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (34, "C.S. VILLA AVAROA", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (35, "C.S. VIRGEN DE GUADALUPE", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (36, "Hospital Obrero C.N.S", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (37, "SEDES", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (38, "Prosalud", 2, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (39, "U.E. ALBERTO BALDIVIESO", 3, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (40, "U.E. AVELINA RAÑA", 3, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (41, "U.E. JOSE MANUEL BELGRANO", 3, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (42, "U.E. BOLIVIA", 3, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (43, "U.E. CARMEN MEALLA", 3, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (44, "U.E. COLEGIO NACIONAL SAN LUIS", 3, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (45, "U.E. FELIPE PALAZON", 3, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (46, "U.E. LA SALLE", 3, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (47, "Universidad Autónoma Juan Mishael Saracho", 3, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (48, "Universidad Católica Boliviana", 3, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (49, "Instituto Tecnologico Agropecuario San Andres", 3, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (50, "Infocal", 3, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (51, "Junta Vecinal", 4, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (52, "Club Pumas Chapacos", 4, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (53, "Asociacion de Promesantes Chunchos", 4, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (54, "Asociación Conciencia Ecológica", 4, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (55, "Sindicato De Transporte De Pasajeros La Tablada", 4, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (56, "Federacion departamental de auto transporte 15 de abril", 4, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (57, "Asociación de comerciantes minorista 20 de Mayo", 4, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (58, "Despacho Municipal", 5, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (59, "Secretaria M. de Infraestructura y Servicios", 5, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (60, "Secretaria M. De Planificación Integral", 5, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (61, "Consejo Municipal", 5, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (62, "Mercado Lourdes", 5, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (63, "Mercado Luis de Fuentes", 5, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (64, "Dirección de ingreso - oficina de parqueos", 5, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (65, "Tercera Division del Ejercito TCNL PADILLA", 6, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (66, "Policía Bolivia FELCC", 6, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (67, "SETAR", 6, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (68, "Cosaalt", 6, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (69, "Servicio Eléctrico Industrial EMSEIQQ", 6, NULL);
INSERT INTO instituciones (id, nombre, id_tipo, id_distrito) VALUES (70, "Camara departamental de transporte", 6, NULL);

CREATE TABLE tecnicos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cargo VARCHAR(100),
    tipo_contrato VARCHAR(100),
    fecha_ingreso DATE,
    celular VARCHAR(50),
    fecha_nacimiento DATE,
    tipo_sangre VARCHAR(10),
    contacto_emergencia VARCHAR(100),
    celular_emergencia VARCHAR(50),
    foto LONGTEXT
);
INSERT INTO tecnicos (id, nombre) VALUES (1, "Ing. Cimar Farfan");
INSERT INTO tecnicos (id, nombre) VALUES (2, "Ing. Karina Castro");
INSERT INTO tecnicos (id, nombre) VALUES (3, "Ing. Cesar Vega");
INSERT INTO tecnicos (id, nombre) VALUES (4, "Ing. Edwin Lopez");
INSERT INTO tecnicos (id, nombre) VALUES (5, "Ing. Jorge Candia");
INSERT INTO tecnicos (id, nombre) VALUES (6, "Ing. Pablo Bonilla");
INSERT INTO tecnicos (id, nombre) VALUES (7, "Tec. Kevin Flores");

CREATE TABLE especies (
    id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);
INSERT INTO especies (id, nombre) VALUES (1, "Acacia (Aromo)");
INSERT INTO especies (id, nombre) VALUES (2, "Alcornoque (Quercus suber l.)");
INSERT INTO especies (id, nombre) VALUES (3, "Algarrobo (Prosopis spp.)");
INSERT INTO especies (id, nombre) VALUES (4, "Arce (Acer spp.)");
INSERT INTO especies (id, nombre) VALUES (5, "Carnaval (Cassia carnaval)");
INSERT INTO especies (id, nombre) VALUES (6, "Casuarina (Casuarina equisetifolia)");
INSERT INTO especies (id, nombre) VALUES (7, "Ceibo (Erythrina crista-galli)");
INSERT INTO especies (id, nombre) VALUES (8, "Chañar (Geoffroea decorticans)");
INSERT INTO especies (id, nombre) VALUES (9, "Churqui (Acacia (Aromo) caven)");
INSERT INTO especies (id, nombre) VALUES (10, "Ciprés (Cupressus spp.)");
INSERT INTO especies (id, nombre) VALUES (11, "Ciruelo (Prunus domestica)");
INSERT INTO especies (id, nombre) VALUES (12, "Cucarda (hibiscus rosa-sinensis)");
INSERT INTO especies (id, nombre) VALUES (13, "Crespón (lagerstroemia indica)");
INSERT INTO especies (id, nombre) VALUES (14, "Eucalipto (eucalyptus spp.)");
INSERT INTO especies (id, nombre) VALUES (15, "Fresno (fraxinus spp.)");
INSERT INTO especies (id, nombre) VALUES (16, "Grevillea (grevillea robusta)");
INSERT INTO especies (id, nombre) VALUES (17, "Guaranguay (schinopsis balansae)");
INSERT INTO especies (id, nombre) VALUES (18, "Jarca (Vachellia aroma)");
INSERT INTO especies (id, nombre) VALUES (19, "Lapacho blanco (handroanthus serratifolius)");
INSERT INTO especies (id, nombre) VALUES (20, "Lapacho rosado (handroanthus impetiginosus)");
INSERT INTO especies (id, nombre) VALUES (21, "Lapacho amarillo (handroanthus albus)");
INSERT INTO especies (id, nombre) VALUES (22, "Lapacho morado (handroanthus heptaphyllus)");
INSERT INTO especies (id, nombre) VALUES (23, "Lapacho negro (handroanthus chrysanthus)");
INSERT INTO especies (id, nombre) VALUES (24, "Laurel (ocotea spp.)");
INSERT INTO especies (id, nombre) VALUES (25, "Lecherón (euphorbia cotinifolia)");
INSERT INTO especies (id, nombre) VALUES (26, "Leucacia (leucaena leucocephala)");
INSERT INTO especies (id, nombre) VALUES (27, "Ligustre (ligustrum lucidum)");
INSERT INTO especies (id, nombre) VALUES (28, "Limonero (citrus limon)");
INSERT INTO especies (id, nombre) VALUES (29, "Mora (Morus nigra)");
INSERT INTO especies (id, nombre) VALUES (30, "Mara (Swietenia macrophylla King)");
INSERT INTO especies (id, nombre) VALUES (31, "Molle (schinus molle)");
INSERT INTO especies (id, nombre) VALUES (32, "Naranjo (citrus sinensis)");
INSERT INTO especies (id, nombre) VALUES (33, "Níspero (eriobotrya japonica)");
INSERT INTO especies (id, nombre) VALUES (34, "Nogal (juglans spp.)");
INSERT INTO especies (id, nombre) VALUES (35, "Olmo (ulmus spp.)");
INSERT INTO especies (id, nombre) VALUES (36, "Palmera (arecaceae spp.)");
INSERT INTO especies (id, nombre) VALUES (37, "Motacú (attalea phalerata)");
INSERT INTO especies (id, nombre) VALUES (38, "Janchicha (parajubaea sunkha)");
INSERT INTO especies (id, nombre) VALUES (39, "Acai boliviano (euterpe precatoria)");
INSERT INTO especies (id, nombre) VALUES (40, "Palma real (syagrus romanzoffiana)");
INSERT INTO especies (id, nombre) VALUES (41, "Pachiuva (socratea exorrhiza)");
INSERT INTO especies (id, nombre) VALUES (42, "Paraíso (melia azedarach)");
INSERT INTO especies (id, nombre) VALUES (43, "Pino (pinus spp.)");
INSERT INTO especies (id, nombre) VALUES (44, "Sauce (salix spp.)");
INSERT INTO especies (id, nombre) VALUES (45, "Senasina (senna spectabilis)");
INSERT INTO especies (id, nombre) VALUES (46, "Taco (erythrina spp.)");
INSERT INTO especies (id, nombre) VALUES (47, "Tarco (jacaranda mimosifolia)");
INSERT INTO especies (id, nombre) VALUES (48, "Timboy (enterolobium contortisiliquum)");
INSERT INTO especies (id, nombre) VALUES (49, "Toborochi (ceiba speciosa)");
INSERT INTO especies (id, nombre) VALUES (50, "Mara (swietenia macrophylla)");
INSERT INTO especies (id, nombre) VALUES (51, "Bolaina (guazuma crinita)");
INSERT INTO especies (id, nombre) VALUES (52, "Camajuu (terminalia oblonga)");
INSERT INTO especies (id, nombre) VALUES (53, "Cuyoja (anadenanthera colubrina)");
INSERT INTO especies (id, nombre) VALUES (54, "Soto (schinopsis haenkeana)");
INSERT INTO especies (id, nombre) VALUES (55, "Aliso (alnus acuminata)");
INSERT INTO especies (id, nombre) VALUES (56, "Palo santo (bursera graveolens)");
INSERT INTO especies (id, nombre) VALUES (57, "Urundéy (astronium urundeuva)");
INSERT INTO especies (id, nombre) VALUES (58, "Molle chileno (Schinus molle)");
INSERT INTO especies (id, nombre) VALUES (59, "Rosa laurel (Nerium oleander)");
INSERT INTO especies (id, nombre) VALUES (60, "Pata de vaca (Bauhinia forficata)");
INSERT INTO especies (id, nombre) VALUES (61, "Brachichito (Brachychiton populneus)");
INSERT INTO especies (id, nombre) VALUES (62, "Higuera (Ficus carica)");
INSERT INTO especies (id, nombre) VALUES (63, "Rum Rum (Virapita Rum rum)");
INSERT INTO especies (id, nombre) VALUES (64, "Tipa (Tipuana tipu)");
INSERT INTO especies (id, nombre) VALUES (65, "No Determinado");

CREATE TABLE acciones (
    id INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);
INSERT INTO acciones (id, nombre) VALUES (1, "Poda de Formación – Corte de ramas secas, elevacion de copa y despeje de pantalla");
INSERT INTO acciones (id, nombre) VALUES (2, "Despunte - Poda de reducción de copa, reducción controlada del tamaño del árbol para evitar riesgos");
INSERT INTO acciones (id, nombre) VALUES (3, "Derribe Controlado – Eliminación total del árbol por riesgo, daño estructural, arbol seco, arbol podrido y arbol inclinado");
INSERT INTO acciones (id, nombre) VALUES (4, "Emergencia - Arbol caido o por caer, arbol seco, arbol podrido y arbol muy inclinado");
INSERT INTO acciones (id, nombre) VALUES (5, "Poda de Raíces – Corte de raíces que afectan pavimentos o estructuras cercanas");
INSERT INTO acciones (id, nombre) VALUES (6, "Extracción de Tocón – Remoción del tronco y raíces después de la tala para evitar brotes o plagas");
INSERT INTO acciones (id, nombre) VALUES (7, "Poda General y otros segun criterio tecnico (levantado de copa, despeje de pantalla, despunte, derribe)");
INSERT INTO acciones (id, nombre) VALUES (8, "No Determinado");

CREATE TABLE solicitudes (
    id_solicitud INT AUTO_INCREMENT PRIMARY KEY,
    fecha_ingreso DATE,
    fecha_verificacion DATE,
    comunicacion_interna VARCHAR(50),
    id_barrio INT,
    id_nombre_institucional INT,
    id_accion INT,
    id_especie INT,
    calle VARCHAR(255),
    numero_casa VARCHAR(50),
    referencia VARCHAR(255),
    solicitante_nombre VARCHAR(100),
    solicitante_telefono VARCHAR(50),
    lo_solicitado TEXT,
    id_accion_solicitada INT,
    id_tecnico_verificacion INT,
    requiere_plataforma BOOLEAN,
    requiere_setar BOOLEAN,
    requiere_ficha_tecnica BOOLEAN,
    procede BOOLEAN,
    cantidad_notas INT,
    arbol_seco BOOLEAN,
    es_emergencia BOOLEAN,
    nivel_urgencia VARCHAR(50),
    observacion_verificacion TEXT,
    id_tecnico_ejecucion INT,
    fecha_ejecucion DATE,
    observaciones_finales TEXT,
    estado_tramite VARCHAR(50),
    FOREIGN KEY (id_barrio) REFERENCES barrios(id),
    FOREIGN KEY (id_nombre_institucional) REFERENCES instituciones(id),
    FOREIGN KEY (id_accion) REFERENCES acciones(id),
    FOREIGN KEY (id_especie) REFERENCES especies(id),
    FOREIGN KEY (id_accion_solicitada) REFERENCES acciones(id),
    FOREIGN KEY (id_tecnico_verificacion) REFERENCES tecnicos(id),
    FOREIGN KEY (id_tecnico_ejecucion) REFERENCES tecnicos(id)
);

-- Tabla de Usuarios para el Sistema
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    cargo VARCHAR(100),
    email VARCHAR(100),
    estado VARCHAR(20) DEFAULT 'Activo',
    foto LONGTEXT
);

-- Insertar usuarios iniciales
INSERT INTO usuarios (username, password, role, nombre, cargo, email, estado) VALUES 
('admin', 'admin', 'ADMIN', 'Ing. Cimar Farfan', 'Ingeniero', 'cfarfan@alcaldiatarija.gob.bo', 'Activo'),
('root', 'password', 'ROOT', 'Tec. Kevin Flores', 'Técnico', 'sistemas.koffys@gmail.com', 'Activo');

INSERT INTO solicitudes VALUES (1, "2024-05-01", "2024-05-03", "Cod 0001/24", 1, NULL, 1, 31, "Av. Las Américas", "S/N", "Frente al parque", "Juan Pérez", "76543210", "Árbol choca con cables, peligro para vecinos.", 1, 1, 1, 1, 0, 1, 1, 0, 0, "Intermedia", "Requiere grúa por la altura", 7, NULL, NULL, "En espera");
INSERT INTO solicitudes VALUES (2, "2024-05-02", "2024-05-04", "Cod 0002/24", 10, 39, 3, 14, "Calle Colón", "123", "Patio central del colegio", "Prof. Martha Llanos", "71122334", "El árbol está seco y amenaza con caer sobre las aulas.", 4, 2, 0, 0, 1, 1, 1, 1, 1, "Alta", "Árbol muerto en pie, riesgo inminente", NULL, NULL, NULL, "En espera");
INSERT INTO solicitudes VALUES (3, "2024-05-03", "2024-05-05", "Cod 0003/24", 23, 19, 5, 43, "Calle Sucre", "S/N", "Acera principal del centro", "Dr. Roberto Méndez", "66453322", "Raíces levantando acera impiden paso de sillas de ruedas.", 5, 3, 0, 0, 0, 1, 2, 0, 0, "Intermedia", "Corte superficial de raíces no afecta estabilidad", 7, "2024-05-06", "Se cortaron 3 raíces expuestas.", "Terminado");
INSERT INTO solicitudes VALUES (4, "2024-05-04", NULL, "Cod 0004/24", 47, NULL, NULL, NULL, "Av. Panamericana", "88", "Al lado de la panadería", "María López", "70221144", "Poda para que el árbol crezca más bonito", 1, NULL, 0, 0, 0, 0, 1, 0, 0, "Baja", NULL, NULL, NULL, NULL, "En espera");
INSERT INTO solicitudes VALUES (5, "2024-05-05", "2024-05-05", "Cod 0005/24", 82, NULL, 6, 20, "Calle Cochabamba", "23", "En media plaza", "Asociación de Vecinos", "66332211", "Sacar el tronco del árbol que talaron el año pasado.", 6, 5, 0, 0, 0, 1, 1, 1, 0, "Baja", "Se necesita maquinaria pesada (retroexcavadora)", NULL, NULL, NULL, "En espera");
INSERT INTO solicitudes VALUES (6, "2024-05-06", "2024-05-06", "Cod 0006/24", 66, 66, 2, 42, "Av. Integración", "S/N", "Oficinas principales", "Comandante Pérez", "77665544", "Ramas tapan las cámaras de seguridad.", 2, 6, 1, 0, 0, 1, 3, 0, 0, "Intermedia", "Poda rápida, pero sí se usa canasta.", 7, "2024-05-07", "Se despejó la visual de 3 cámaras de seguridad.", "Terminado");
