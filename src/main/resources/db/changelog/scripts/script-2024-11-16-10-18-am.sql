ALTER TABLE sah.alimento
ADD COLUMN codigo_imagen varchar(50);

INSERT INTO sah.tipo_alimento (id_tipo_alimento, nombre_tipo_alimento) VALUES
                                                                           (1, 'Postres'),
                                                                           (2, 'Entradas'),
                                                                           (3, 'Platos fuertes'),
                                                                           (4, 'Bebidas');

INSERT INTO sah.tipo_cuarto (id_tipo_cuarto, nombre_tipo_cuarto) VALUES
                                                                     (1, 'Habitación estándar'),
                                                                     (2, 'Suite'),
                                                                     (3, 'Habitación familiar'),
                                                                     (4, 'Suite presidencial');

INSERT INTO sah.tipo_servicio (id_tipo_servicio, nombre_tipo_servicio) VALUES
                                                                           (1, 'Spa'),
                                                                           (2, 'Room Service'),
                                                                           (3, 'Transporte'),
                                                                           (4, 'Tours guiados');


INSERT INTO sah.alimento (codigo_alimento, tiempo_preparacion_alimento, nombre_alimento, detalle_alimento, tipo_alimento_fk, codigo_imagen) VALUES
                                                                                                                                                ('A001', '00:15:00', 'Tiramisú', 'Delicioso postre italiano con café y mascarpone.', 1, 'tiramisu.jpg'),
                                                                                                                                                ('A002', '00:10:00', 'Bruschetta', 'Rebanadas de pan con tomate, albahaca y aceite de oliva.', 2, 'bruschetta.jpg'),
                                                                                                                                                ('A003', '00:30:00', 'Raviolis', 'Pasta rellena con queso y espinacas en salsa de tomate.', 3, 'raviolis.jpg'),
                                                                                                                                                ('A004', '00:05:00', 'Limonada', 'Refrescante bebida de limón recién exprimido.', 4, 'limonada.jpg');

INSERT INTO sah.servicio (codigo_servicio, nombre_servicio, valor_servicio, codigo_imagen_servicio, detalle_servicio, tipo_servicio_fk) VALUES
                                                                                                                                            ('S001', 'Masaje relajante', 50.00, 'masaje.jpg', 'Relaja tus músculos con nuestro masaje de 1 hora.', 1),
                                                                                                                                            ('S002', 'Entrega de desayuno', 15.00, 'desayuno.jpg', 'Desayuno completo entregado a tu habitación.', 2),
                                                                                                                                            ('S003', 'Servicio de taxi', 20.00, 'taxi.jpg', 'Transporte seguro hacia tu destino.', 3),
                                                                                                                                            ('S004', 'Tour a la ciudad', 100.00, 'tour.jpg', 'Explora los lugares más emblemáticos con un guía experto.', 4);

INSERT INTO sah.cuarto (codigo_cuarto, numero_cuarto, codigo_imagen_cuarto, valor_noche_cuarto, detalle_cuarto, tipo_cuarto_fk, estado_cuarto_fk) VALUES
                                                                                                                                                      ('C001', '101', 'habitacion_estandar.jpeg', 80.00, 'Habitación estándar con cama doble y baño privado.', 1, 1),
                                                                                                                                                      ('C002', '202', 'suite.jpeg', 150.00, 'Suite con vista al mar y jacuzzi.', 2, 1),
                                                                                                                                                      ('C003', '303', 'habitacion_familiar.jpg', 120.00, 'Habitación familiar con dos camas dobles.', 3, 2),
                                                                                                                                                      ('C004', '404', 'suite_presidencial.jpg', 300.00, 'Suite presidencial con sala de estar y cocina.', 4, 3);

INSERT INTO sah.cuarto_servicio (codigo_cuarto_fk, codigo_servicio_fk, estado_cuarto_servicio_fk) VALUES
                                                                                                      ('C001', 'S001', 1),
                                                                                                      ('C002', 'S002', 1),
                                                                                                      ('C003', 'S003', 2),
                                                                                                      ('C004', 'S004', 1);
