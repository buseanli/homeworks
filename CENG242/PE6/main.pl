:- module(main, [get_count/3, get_total_price/2, get_rating_of_look/2, get_items_for_requirement/2, is_valid_look/1, generate_look/1, generate_look_for_competition/3]).
:- [kb].

% DO NOT CHANGE THE UPPER CONTENT, WRITE YOUR CODE AFTER THIS LINE

% 5 POINTS
%
% get_count(ItemIDList,Type,ItemCount)
%
% find count of items of Type in a list of ItemIDs.
get_count(ItemIDList,Type,ItemCount) :-
findall(
        ID,
        (   member(ID, ItemIDList),
            item(ID, Type, _, _, _, _)
        ),
        Matches
    ),
    length(Matches, ItemCount).

% 5 POINTS
%
% get_total_price(ItemIDList,TotalPrice)
%
% find the total price of items of Type in a list of ItemIDs.
get_total_price(ItemIDList,TotalPrice) :-
    findall(
        Price,
        (   member(ID, ItemIDList),
            item(ID, _, _, _, Price, _)
        ),
        Prices
    ),
    sum_list(Prices, TotalPrice).

    

% 5 POINTS
%
% get_rating_of_look(ItemIDList,Rating)
%
% rating of a look is the average rating of the items in that look.
% get the average rating of items in a list of ItemIDs.
get_rating_of_look([], 0).
get_rating_of_look(ItemIDList, Rating) :-
    ItemIDList \= [],
    findall(
        R,
        (   member(ID, ItemIDList),
            item(ID, _, _, _, _, R)
        ),
        Ratings
    ),
    sum_list(Ratings, Sum),
    length(Ratings, Len),
    Len > 0,
    Rating is Sum // Len.


% 10 POINTS
% get_items_for_requirement(Requirement,ItemIDList)
%
% get all items that fit a given requirement.
% each "Requirement" is a 3-tuple of the form (Type,Colour,Style).
% however, not all fields need to be specified. 
% following are all valid Requirements:
% - (Type,Colour,Style)
% - (_,Colour,Style)
% - (Type,_,Style)
% - (Type,Colour,_)
% - (_,_,Style)
% - (Type,_,_)
% - (_,Colour,_)
% - (_,_,_)
get_items_for_requirement((ReqType, ReqColor, ReqStyle), ItemIDList) :-
    findall(
        ID,
        (   item(ID, T, C, S, _, _),
            ( var(ReqType)  -> true ; ReqType  = T ),
            ( var(ReqColor) -> true ; ReqColor = C ),
            ( var(ReqStyle) -> true ; ReqStyle = S )
        ),
        ItemIDList
    ).


% 15 POINTS
% is_valid_look(ItemIDList)
%
% a valid look should have:
% either
%	a "singlepiece" item 
% or
% 	one "top" item and one "bottom" item
% and also
% - at most three "accessory" items (can be zero)
% - at most one "shoe" item (can be zero)
% - at most one "jacket" item (can be zero)
is_valid_look(ItemIDList) :-
    get_count(ItemIDList, singlepiece, SP),
    get_count(ItemIDList, top,       Top),
    get_count(ItemIDList, bottom,    Bottom),
    get_count(ItemIDList, accessory, Acc),
    get_count(ItemIDList, shoe,      Shoe),
    get_count(ItemIDList, jacket,    Jacket),
    (
        (SP =:= 1, Top =:= 0, Bottom =:= 0)
      ;
        (SP =:= 0, Top =:= 1, Bottom =:= 1)
    ),
    Acc    =< 3,
    Shoe   =< 1,
    Jacket =< 1.


% 20 POINTS
% is_look_valid_for_competition(CompetitionID,ItemIDList)
%
% a look is valid for a competition if it is a valid look and there is
% at least one item in the look that fits the competition requirement.
is_look_valid_for_competition(CompetitionID,ItemIDList):-
    nonvar(CompetitionID),
    nonvar(ItemIDList),
    competition(CompetitionID, (ReqType, ReqColor, ReqStyle)),
    is_valid_look(ItemIDList),
    member(ID, ItemIDList),
    item(ID, T, C, S, _, _),
    ( var(ReqType)  -> true ; ReqType  = T ),
    ( var(ReqColor) -> true ; ReqColor = C ),
    ( var(ReqStyle) -> true ; ReqStyle = S ),
    !.


make_subset([], []).
make_subset([H|T], [H|R]) :-
    make_subset(T, R).
make_subset([_|T], R) :-
    make_subset(T, R).


% 20 POINTS
% generate_look(ItemIDList) 
%
% generate a new valid look from all items with each ";" press.
generate_look(ItemIDList) :-
    findall(ID, item(ID, _, _, _, _, _), AllIDs),
    make_subset(AllIDs, ItemIDList),
    ItemIDList \= [],
    is_valid_look(ItemIDList).

	

% 10 POINTS
% generate_look_for_competition(UserID,CompetitionID,ItemIDList)
% 
% for a user to enter a competition:
% - they must be able to afford a look
% - the look must fit the competition requirements
% generate a new look with each ";" press.
%
% hint: you can combine "is_look_valid_for_competition" and "generate_look"
% other solutions are also accepted.
generate_look_for_competition(UserID, CompetitionID, ItemIDList) :-
    user(UserID, Money),
    generate_look(ItemIDList),
    is_look_valid_for_competition(CompetitionID, ItemIDList),
    get_total_price(ItemIDList, Price),
    Price =< Money.

generate_look_for_competition(_, _, []).


% 10 POINTS
% get_highest_rated_look(ListOfLooks,BestLook)
%
% given a list of looks, find the look with the highest rating.
get_highest_rated_look([Single], Single).
get_highest_rated_look([L1, L2 | Rest], Best) :-
    get_rating_of_look(L1, R1),
    get_rating_of_look(L2, R2),
    (   R1 >= R2
    ->  get_highest_rated_look([L1 | Rest], Best)
    ;   get_highest_rated_look([L2 | Rest], Best)
    ).
