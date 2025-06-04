package com.prueba.pruebatecnica.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Entity
@Table(name = "eps")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Eps {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    @NotBlank(message = "El nombre de la EPS es obligatorio")
    private String nombre;

    @Column(unique = true, nullable = false, length = 10)
    @NotBlank(message = "El código de la EPS es obligatorio")
    private String codigo;

    @Column(nullable = false)
    @Builder.Default
    private Boolean activo = true;
}
