CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'empleado',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS empleados (
    id SERIAL PRIMARY KEY,
    fecha_ingreso DATE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    salario NUMERIC(10,2) NOT NULL,
    UNIQUE(nombre)
);

CREATE TABLE IF NOT EXISTS solicitudes (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    resumen VARCHAR(255) NOT NULL,
    id_empleado INTEGER NOT NULL,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id) ON DELETE CASCADE
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_empleados_nombre ON empleados(nombre);
CREATE INDEX IF NOT EXISTS idx_solicitudes_empleado ON solicitudes(id_empleado);
CREATE INDEX IF NOT EXISTS idx_solicitudes_codigo ON solicitudes(codigo);

-- Datos de prueba
INSERT INTO users (email, password, nombre, role) VALUES
('admin@test.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj2wH/QfgEPS', 'Administrador', 'admin'),
('empleado@test.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj2wH/QfgEPS', 'Empleado Test', 'empleado')
ON CONFLICT (email) DO NOTHING;
-- Contraseña para ambos: password123

INSERT INTO empleados (fecha_ingreso, nombre, salario) VALUES
('2023-01-15', 'Juan Pérez', 3500000.00),
('2023-03-22', 'María García', 4200000.00),
('2023-06-10', 'Carlos López', 3800000.00),
('2023-09-05', 'Ana Martínez', 4500000.00),
('2023-11-18', 'Luis Rodríguez', 3200000.00)
ON CONFLICT (nombre) DO NOTHING;

INSERT INTO solicitudes (codigo, descripcion, resumen, id_empleado) VALUES
('SOL-001', 'Solicitud de vacaciones', 'Vacaciones de verano por 15 días', 1),
('SOL-002', 'Solicitud de permiso médico', 'Permiso por cita médica especializada', 2),
('SOL-003', 'Solicitud de capacitación', 'Curso de desarrollo profesional', 3),
('SOL-004', 'Solicitud de equipos', 'Nuevo equipo de cómputo para desarrollo', 1),
('SOL-005', 'Solicitud de horario flexible', 'Ajuste de horario por estudios', 4)
ON CONFLICT (codigo) DO NOTHING;

-- Función para updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para users
CREATE TRIGGER update_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
