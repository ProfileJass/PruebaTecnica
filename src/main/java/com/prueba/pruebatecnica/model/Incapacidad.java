package com.prueba.pruebatecnica.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "incapacidades")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Incapacidad {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "numero_radicado", unique = true, nullable = false, length = 20)
    private String numeroRadicado;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "eps_id", nullable = false)
    private Eps eps;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "historico_empleado_id", nullable = false)
    private HistoricoEmpleado historicoEmpleado;

    @Column(name = "fecha_inicio", nullable = false)
    @NotNull(message = "La fecha de inicio es obligatoria")
    private LocalDate fechaInicio;

    @Column(name = "fecha_fin", nullable = false)
    @NotNull(message = "La fecha de fin es obligatoria")
    private LocalDate fechaFin;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private EstadoIncapacidad estado = EstadoIncapacidad.PENDIENTE;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_creador_id", nullable = false)
    private Usuario usuarioCreador;

    @Column(name = "fecha_creacion", nullable = false)
    @Builder.Default
    private LocalDateTime fechaCreacion = LocalDateTime.now();

    @Column(name = "fecha_actualizacion")
    private LocalDateTime fechaActualizacion;

    @PreUpdate
    public void preUpdate() {
        this.fechaActualizacion = LocalDateTime.now();
    }

    public enum EstadoIncapacidad {
        PENDIENTE("pendiente"),
        EN_CURSO("en_curso"),
        COMPLETADO("completado");

        private final String valor;

        EstadoIncapacidad(String valor) {
            this.valor = valor;
        }

        public String getValor() {
            return valor;
        }
    }
}