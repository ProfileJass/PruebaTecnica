package com.prueba.pruebatecnica.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "retiros_empleados")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RetiroEmpleado {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Empleado retirado
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    // Fecha del retiro (solo fecha, sin hora)
    @Column(name = "fecha_retiro", nullable = false)
    private LocalDate fechaRetiro;

    // Motivo del retiro
    @Column(columnDefinition = "TEXT")
    private String motivo;

    // Administrador que registró el retiro
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_administrador_id", nullable = false)
    private Usuario usuarioAdministrador;

    // Fecha y hora en que se registró el retiro (por defecto: ahora)
    @Column(name = "fecha_registro", nullable = false)
    @Builder.Default
    private LocalDateTime fechaRegistro = LocalDateTime.now();
}