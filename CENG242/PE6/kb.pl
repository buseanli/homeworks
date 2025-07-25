% CHANGES DONE TO THIS FILE WILL BE OVERWRITTEN. 
% IT WILL HAVE NO EFFECT ON YOUR GRADE.

:- module(kb, [user/2, item/6, competition/2]).


% Problem 
% 
% Seeing the success of new generation doll dress up games, 
% your friend decides to make their own version.
% You want to help them, but to make it different from others,
% you decide to use Prolog.
%
% Game has users, items, and competitions.
% Users are identified with their UserID.
% Items are identified with their ItemID, they also have:
% - Type: singlepiece, top, bottom, accessory, shoe, jacket
% - Colour: colour of the item such as black, golden, multicolour
% - Style: a specific tag identifying the style of the item such as casual, chic, gothic
% - Price: how much of their money a user must spend to use the look in a competition
% - Rating: the rating of the item between 1 and 5 - the higher the better.
%
% The goal of the game is creating a look from items to enter competitions.
% Competitions have requirements that limit what items you can use in looks.
% Users must afford to buy the items to create a look with that item.



% user(UserID,Money)
% users and the amount of money they have in the game.
user(u1,23000).
user(u2,2100).
user(u3,4500).
user(u4,200).
user(u5,1300).


% item(ItemID,Type,Colour,Style,Price,Rating)
% clothing items that users can buy to create looks.
item(i01,singlepiece,black,gothic,2000,5).
item(i02,singlepiece,golden,chic,800,5).
item(i03,top,multicolour,casual,340,3).
item(i04,top,yellow,casual,120,2).
item(i05,top,pink,cute,900,5).
item(i06,top,green,casual,490,4).
item(i07,bottom,blue,chic,1000,5).
item(i08,bottom,green,casual,750,4).
item(i09,bottom,yellow,cute,540,3).
item(i10,bottom,black,casual,50,1).
item(i11,shoe,black,gothic,280,4).
item(i12,shoe,black,chic,140,3).
item(i13,accessory,red,cute,280,3).
item(i14,accessory,golden,casual,450,5).
item(i15,accessory,black,gothic,10,1).
item(i16,jacket,black,gothic,3200,5).


% competition(CompetitionID,Requirement)
% "Requirement" is a 3-tuple of the form (Type,Colour,Style).
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
competition(c1,(_,multicolour,casual)).
competition(c2,(_,_,_)).
competition(c3,(_,_,gothic)).
competition(c4,(_,green,_)).
competition(c5,(accessory,_,cute)).