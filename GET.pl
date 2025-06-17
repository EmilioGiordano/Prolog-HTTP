:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/json_convert)).

:- dynamic enlace/2.

% Hechos
enlace('DPD', 'www.dpd.com').
enlace('CEX', 'www.CEX.com').
enlace('OnTime', 'www.OnTime.com').

% Handlers
:- http_handler('/enlaces', obtener_enlaces, []).
:- http_handler(root(enlace/N), obtener_enlace_por_nombre, [method(get)]).

% GET /enlaces
obtener_enlaces(_Request) :-
    findall(
        _{agencia: Agencia, url: URL},
        enlace(Agencia, URL),
        Enlaces
    ),
    reply_json_dict(Enlaces).

% GET /enlace/AGENCIA
obtener_enlace_por_nombre(Request) :-
    http_dispatch:request_uri(Request, URI),
    atomic_list_concat(['/enlace', NombreAtom], '/', URI),
    atom_string(NombreAtom, Nombre),
    ( enlace(Nombre, URL) ->
        reply_json_dict(_{agencia: Nombre, url: URL})
    ; reply_json_dict(_{error: "Agencia no encontrada"}, [status(404)])
    ).

% Servidor
:- initialization(http_server(http_dispatch, [port(8080)])).
