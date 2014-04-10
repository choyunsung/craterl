-module(craterl_sup).
 
-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok,
      {{one_for_one, 5, 10},
        [{config_provider,
          {config_provider, start_link, []},
          permanent,
          5000,
          worker,
          [config_provider]},
         {crate_req_sup,
          {crate_request_handler_sup, start_link, []},
          permanent,
          5000,
          supervisor,
          [crate_request_handler_sup]},
         {crate_connection_manager,
          {connection_manager, start_link, []},
          permanent,
          5000,
          worker,
          [connection_manager]}
        ]
      }
    }.
