:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/json_convert)).

:- dynamic enlace/2.

% Hechos
enlace('DPD', 'www.dpd.com').
enlace('CEX', 'www.CEX.com').
enlace('OnTime', 'www.OnTime.com').

% Registro de endpoint
:- http_handler('/enlaces', obtener_enlaces, []).

% Handler del GET
obtener_enlaces(_Request) :-
    findall(
        _{agencia: Agencia, url: URL},
        enlace(Agencia, URL),
        Enlaces
    ),
    reply_json_dict(Enlaces).

% Inicialización del servidor en puerto 8080
:- initialization(http_server(http_dispatch, [port(8080)])).
