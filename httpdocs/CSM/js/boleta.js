document.addEventListener('DOMContentLoaded', mostrarDatosEnvio);

        function mostrarDatosEnvio() {
            console.time('Total fetch time');
            console.time('Show loading message');
        
            // Muestra el mensaje de carga
            document.getElementById('loadingMessage').style.display = 'block';
            console.timeEnd('Show loading message');
        
            // Obtén los parámetros de la URL
            const urlParams = new URLSearchParams(window.location.search);
            const envioId = urlParams.get('envio_id');
            const usuarioId = urlParams.get('usuario_id');
            
            if (envioId && usuarioId) {
                
                fetch(`/cgi-bin/Info_envios.pl?envio_id=${envioId}&usuario_id=${usuarioId}`)
                    .then(response => {
                        if (response.ok) {
                            return response.json();
                        } else {
                            throw new Error('Error en la solicitud: ' + response.status);
                        }
                    })
                    .then(data => {
                        
                        if (data && !data.error) {
                            // Oculta el mensaje de carga
                            document.getElementById('loadingMessage').style.display = 'none';
                            
                            // Muestra los datos del envío en el HTML
                            document.getElementById('boleta').innerHTML = `
                                <h2>Resumen del Envío</h2>
                                <p><strong>Envío ID:</strong> ${data.envio_id}</p>
                                <p><strong>Nombres:</strong> ${data.cliente_nombres}</p>
                                <p><strong>Apellidos:</strong> ${data.cliente_apellidos}</p>
                                <p><strong>Origen:</strong> ${data.direccion_origen || 'No disponible'}</p>
                                <p><strong>Destino:</strong> ${data.direccion_destino || 'No disponible'}</p>
                                <p><strong>Descripción:</strong> ${data.descripcion}</p>
                                <p><strong>Costo:</strong> S/${data.costo}</p>
                                
                                <p><strong>Seguimiento:</strong> ${data.numero_seguimiento}</p>
                                
                            `;
                        } else {
                            document.getElementById('boleta').innerHTML = '<p>No se encontraron datos para el envío.</p>';
                        }
                        
                    })
                    .catch(error => {
                        document.getElementById('loadingMessage').style.display = 'none';
                        document.getElementById('boleta').innerHTML = '<p>Error al obtener los datos del envío.</p>';
                        console.error('Error al obtener los datos del envío:', error);
                        
                    });
            } else {
                document.getElementById('loadingMessage').style.display = 'none';
                document.getElementById('boleta').innerHTML = '<p>No se encontraron los parámetros necesarios en la URL.</p>';
            }
        }
        
        function agregarOtroCliente() {
            // Obtén el usuario_id de la URL
            const urlParams = new URLSearchParams(window.location.search);
            const usuarioId = urlParams.get('usuario_id');
            
            if (usuarioId) {
                // Redirige al formulario de nuevo cliente con el usuario_id en la URL
                window.location.href = `Envios.html?usuario_id=${usuarioId}`;
            } else {
                alert('No se encontró el ID del usuario.');
            }
        }
            
        