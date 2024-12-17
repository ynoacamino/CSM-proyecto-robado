

// Definir precios fijos entre ciudades
const precios = {
    "arequipa-camana": 15,
    "arequipa-caraveli": 20,
    "arequipa-castilla": 18,
    "arequipa-caylloma": 22,
    "arequipa-condesuyos": 25,
    "arequipa-islay": 30,
    "arequipa-la_union": 28,
    "camana-caraveli": 18,
    "camana-castilla": 16,
    "camana-caylloma": 20,
    "camana-condesuyos": 22,
    "camana-islay": 27,
    "camana-la_union": 24,
    "caraveli-castilla": 16,
    "caraveli-caylloma": 18,
    "caraveli-condesuyos": 20,
    "caraveli-islay": 22,
    "caraveli-la_union": 20,
    "castilla-caylloma": 14,
    "castilla-condesuyos": 16,
    "castilla-islay": 20,
    "castilla-la_union": 18,
    "caylloma-condesuyos": 22,
    "caylloma-islay": 25,
    "caylloma-la_union": 24,
    "condesuyos-islay": 28,
    "condesuyos-la_union": 26,
    "islay-la_union": 30,

// Precios para envíos dentro de la misma región
    "arequipa-arequipa": 10,
    "camana-camana": 10,
    "caraveli-caraveli": 10,
    "castilla-castilla": 10,
    "caylloma-caylloma": 10,
    "condesuyos-condesuyos": 10,
    "islay-islay": 10,
    "la_union-la_union": 10
};

function calcularMonto() {
    const origen = document.getElementById('origen').value;
    const destino = document.getElementById('destino').value;

    if (origen && destino) {
        const clave = `${origen}-${destino}`;
        const claveInversa = `${destino}-${origen}`;
        const precio = precios[clave] || precios[claveInversa] || "Precio no disponible";

        if (precio === "Precio no disponible") {
            document.getElementById('monto-estimado').textContent = 'No hay un precio definido para su envío';
            document.getElementById('costo').value = '';
        } else {
            document.getElementById('monto-estimado').textContent = `El monto estimado para el envío es S/${precio}`;
            document.getElementById('costo').value = precio;  // Asignar el precio al campo oculto
        }
    } else {
        document.getElementById('monto-estimado').textContent = '';
        document.getElementById('costo').value = '';  // Limpiar el campo oculto si no hay origen o destino
    }
}


// Extraer el usuario_id de la URL
function getQueryParam(param) {
    let urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(param);
}

// Asignar el usuario_id al campo oculto
document.getElementById('usuario_id').value = getQueryParam('usuario_id');

