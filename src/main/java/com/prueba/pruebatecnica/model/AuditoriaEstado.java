package com.prueba.pruebatecnica.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "auditoria_estados")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AuditoriaEstado {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "incapacidad_id", nullable = false)
    private Incapacidad incapacidad;

    @Column(name = "estado_anterior", length = 20)
    private String estadoAnterior;

    @Column(name = "estado_nuevo", nullable = false, length = 20)
    private String estadoNuevo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @Column(name = "fecha_cambio", nullable = false)
    @Builder.Default
    private LocalDateTime fechaCambio = LocalDateTime.now();

    @Column(columnDefinition = "TEXT")
    private String observaciones;
}
