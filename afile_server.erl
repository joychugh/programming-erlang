%%%-------------------------------------------------------------------
%%% @author jchugh
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Nov 2015 4:49 PM
%%%-------------------------------------------------------------------
-module(afile_server).
-author("jchugh").

%% API
-export([start/1, loop/1]).

start(Dir) -> spawn(afile_server, loop, [Dir]).

loop(Dir) ->
    receive
        {Client, list_dir} ->
            Client ! {self(), file:list_dir(Dir)};
        {Client, {get_file, File}} ->
            Full = filename:join(Dir, File),
            Client ! {self(), file:read_file(Full)};
        {Client, {put_file, File, Content}} ->
            Full = filename:join(Dir, File),
            Client ! {self(), file:write_file(Full, Content)}
    end,
    loop(Dir).