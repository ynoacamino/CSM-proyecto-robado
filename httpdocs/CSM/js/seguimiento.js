document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('seguimientoForm');
    const resultado = document.getElementById('resultado');

    form.addEventListener('submit', event => {
        event.preventDefault();

        const numeroSeguimiento = document.getElementById('numero_seguimiento').value;

        // Envía la solicitud al script Perl
        fetch(`/cgi-bin/seguimiento_envio.pl?numero_seguimiento=${numeroSeguimiento}`)
            .then(response => {
                if (response.ok) {
                    return response.json();
                } else {
                    throw new Error('Error en la solicitud: ' + response.statusText);
                }
            })
            .then(data => {
                if (data.error) {
                    resultado.innerHTML = `<p>${data.error}</p>`;
                } else {
                    let estadoHTML = '';
                    if (data.estado === 'pendiente') {
                        estadoHTML = '<strong>Estado:</strong> Pendiente';
                    } else if (data.estado === 'en camino') {
                        estadoHTML = '<strong>Estado:</strong> En Camino';
                    } else if (data.estado === 'entregado') {
                        estadoHTML = `<strong>Estado:</strong> Entregado`;
                    } else {
                        estadoHTML = `<strong>Estado:</strong> Desconocido`;
                    }

                    resultado.innerHTML = `
                        <h2>Estado del Envío</h2>
                        <p><strong>Envío ID:</strong> ${data.envio_id}</p>
                        <p><strong>Nombres:</strong> ${data.cliente_nombres}</p>
                        <p><strong>Apellidos:</strong> ${data.cliente_apellidos}</p>
                        <p><strong>Origen:</strong> ${data.direccion_origen || 'No disponible'}</p>
                        <p><strong>Destino:</strong> ${data.direccion_destino || 'No disponible'}</p>
                        <p><strong>Descripción:</strong> ${data.descripcion}</p>
                        <p><strong>Costo:</strong> S/${data.costo}</p>
                        <p><strong>Hora de Salida:</strong> ${data.hora_salida}</p>
                        <p><strong>Hora de Llegada:</strong> ${data.hora_llegada}</p>
                        ${estadoHTML}
                    `;
                }
            })
            .catch(error => {
                console.error('Error al obtener datos del seguimiento:', error);
                resultado.innerHTML = '<p>Error al obtener datos del seguimiento.</p>';
            });
    });
});
