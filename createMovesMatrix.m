function [territory,movesMatrix] = createMovesMatrix
% Creates the matrix of possible moves from any territory to any other
% territory
%% Define territory border coordinates
territory = load('territory_borders.mat');

%% Define territory centers
temp = load('territory_centers.mat');
territory.center = temp.center;

%% Define territory number of armies
territory.armies = zeros(42,1);

%% Define territory numbers
territory.num.Alaska = 1;
territory.num.NorthWesternTerritory = 2;
territory.num.Alberta = 3;
territory.num.Greenland = 4;
territory.num.Ontario = 5;
territory.num.Quebec = 6;
territory.num.WestUSA = 7;
territory.num.EastUSA = 8;
territory.num.CentralAmerica = 9;
territory.num.Venezuela = 10;
territory.num.Brasil = 11;
territory.num.Peru = 12;
territory.num.Argentina = 13;
territory.num.Iceland = 14;
territory.num.GreatBritain = 15;
territory.num.Scandinavia = 16;
territory.num.NorthernEurope = 17;
territory.num.WesternEurope = 18;
territory.num.EasternEurope = 19;
territory.num.SouthernEurope = 20;
territory.num.NorthernAfrica = 21;
territory.num.Egypt = 22;
territory.num.Congo = 23;
territory.num.EastAfrica = 24;
territory.num.SouthAfrica = 25;
territory.num.Madagascar = 26;
territory.num.MiddleEast = 27;
territory.num.Afghanistan = 28;
territory.num.India = 29;
territory.num.Cyam = 30;
territory.num.China = 31;
territory.num.Mongolia = 32;
territory.num.Japan = 33;
territory.num.Buratia = 34;
territory.num.Ural = 35;
territory.num.Syberia = 36;
territory.num.Yakut = 37;
territory.num.Kamchatka = 38;
territory.num.Indonesia = 39;
territory.num.NewGuinea = 40;
territory.num.WesternAustralia = 41;
territory.num.EasternAustralia = 42;

%% Create the moves matrix (1 if can move from row territory to column territory, 0 otherwise)
movesMatrix = zeros(42);
% 1
movesMatrix(territory.num.Alaska,territory.num.NorthWesternTerritory) = 1;
movesMatrix(territory.num.Alaska,territory.num.Alberta) = 1;
movesMatrix(territory.num.Alaska,territory.num.Kamchatka) = 1;
% 2
movesMatrix(territory.num.NorthWesternTerritory,territory.num.Greenland) = 1;
movesMatrix(territory.num.NorthWesternTerritory,territory.num.Alberta) = 1;
movesMatrix(territory.num.NorthWesternTerritory,territory.num.Ontario) = 1;
movesMatrix(territory.num.NorthWesternTerritory,territory.num.Alaska) = 1;
% 3
movesMatrix(territory.num.Alberta,territory.num.Alaska) = 1;
movesMatrix(territory.num.Alberta,territory.num.NorthWesternTerritory) = 1;
movesMatrix(territory.num.Alberta,territory.num.Ontario) = 1;
movesMatrix(territory.num.Alberta,territory.num.WestUSA) = 1;
% 4
movesMatrix(territory.num.Greenland,territory.num.NorthWesternTerritory) = 1;
movesMatrix(territory.num.Greenland,territory.num.Ontario) = 1;
movesMatrix(territory.num.Greenland,territory.num.Quebec) = 1;
movesMatrix(territory.num.Greenland,territory.num.Iceland) = 1;
% 5
movesMatrix(territory.num.Ontario,territory.num.NorthWesternTerritory) = 1;
movesMatrix(territory.num.Ontario,territory.num.Greenland) = 1;
movesMatrix(territory.num.Ontario,territory.num.Quebec) = 1;
movesMatrix(territory.num.Ontario,territory.num.Alberta) = 1;
movesMatrix(territory.num.Ontario,territory.num.WestUSA) = 1;
movesMatrix(territory.num.Ontario,territory.num.EastUSA) = 1;
% 6
movesMatrix(territory.num.Quebec,territory.num.Ontario) = 1;
movesMatrix(territory.num.Quebec,territory.num.EastUSA) = 1;
movesMatrix(territory.num.Quebec,territory.num.Greenland) = 1;
% 7
movesMatrix(territory.num.WestUSA,territory.num.Alberta) = 1;
movesMatrix(territory.num.WestUSA,territory.num.Ontario) = 1;
movesMatrix(territory.num.WestUSA,territory.num.EastUSA) = 1;
movesMatrix(territory.num.WestUSA,territory.num.CentralAmerica) = 1;
% 8
movesMatrix(territory.num.EastUSA,territory.num.WestUSA) = 1;
movesMatrix(territory.num.EastUSA,territory.num.Ontario) = 1;
movesMatrix(territory.num.EastUSA,territory.num.Quebec) = 1;
movesMatrix(territory.num.EastUSA,territory.num.CentralAmerica) = 1;
% 9
movesMatrix(territory.num.CentralAmerica,territory.num.WestUSA) = 1;
movesMatrix(territory.num.CentralAmerica,territory.num.EastUSA) = 1;
movesMatrix(territory.num.CentralAmerica,territory.num.Venezuela) = 1;
% 10
movesMatrix(territory.num.Venezuela,territory.num.CentralAmerica) = 1;
movesMatrix(territory.num.Venezuela,territory.num.Brasil) = 1;
movesMatrix(territory.num.Venezuela,territory.num.Peru) = 1;
% 11
movesMatrix(territory.num.Brasil,territory.num.Venezuela) = 1;
movesMatrix(territory.num.Brasil,territory.num.NorthernAfrica) = 1;
movesMatrix(territory.num.Brasil,territory.num.Peru) = 1;
movesMatrix(territory.num.Brasil,territory.num.Argentina) = 1;
% 12
movesMatrix(territory.num.Peru,territory.num.Venezuela) = 1;
movesMatrix(territory.num.Peru,territory.num.Brasil) = 1;
movesMatrix(territory.num.Peru,territory.num.Argentina) = 1;
% 13
movesMatrix(territory.num.Argentina,territory.num.Peru) = 1;
movesMatrix(territory.num.Argentina,territory.num.Brasil) = 1;
% 14
movesMatrix(territory.num.Iceland,territory.num.Greenland) = 1;
movesMatrix(territory.num.Iceland,territory.num.GreatBritain) = 1;
movesMatrix(territory.num.Iceland,territory.num.Scandinavia) = 1;
% 15
movesMatrix(territory.num.GreatBritain,territory.num.Iceland) = 1;
movesMatrix(territory.num.GreatBritain,territory.num.Scandinavia) = 1;
movesMatrix(territory.num.GreatBritain,territory.num.NorthernEurope) = 1;
movesMatrix(territory.num.GreatBritain,territory.num.WesternEurope) = 1;
% 16
movesMatrix(territory.num.Scandinavia,territory.num.Iceland) = 1;
movesMatrix(territory.num.Scandinavia,territory.num.GreatBritain) = 1;
movesMatrix(territory.num.Scandinavia,territory.num.NorthernEurope) = 1;
movesMatrix(territory.num.Scandinavia,territory.num.EasternEurope) = 1;
% 17
movesMatrix(territory.num.NorthernEurope,territory.num.Scandinavia) = 1;
movesMatrix(territory.num.NorthernEurope,territory.num.EasternEurope) = 1;
movesMatrix(territory.num.NorthernEurope,territory.num.SouthernEurope) = 1;
movesMatrix(territory.num.NorthernEurope,territory.num.WesternEurope) = 1;
movesMatrix(territory.num.NorthernEurope,territory.num.GreatBritain) = 1;
% 18
movesMatrix(territory.num.WesternEurope,territory.num.GreatBritain) = 1;
movesMatrix(territory.num.WesternEurope,territory.num.NorthernEurope) = 1;
movesMatrix(territory.num.WesternEurope,territory.num.SouthernEurope) = 1;
movesMatrix(territory.num.WesternEurope,territory.num.NorthernAfrica) = 1;
% 19
movesMatrix(territory.num.EasternEurope,territory.num.Scandinavia) = 1;
movesMatrix(territory.num.EasternEurope,territory.num.NorthernEurope) = 1;
movesMatrix(territory.num.EasternEurope,territory.num.SouthernEurope) = 1;
movesMatrix(territory.num.EasternEurope,territory.num.MiddleEast) = 1;
movesMatrix(territory.num.EasternEurope,territory.num.Afghanistan) = 1;
movesMatrix(territory.num.EasternEurope,territory.num.Ural) = 1;
% 20
movesMatrix(territory.num.SouthernEurope,territory.num.NorthernEurope) = 1;
movesMatrix(territory.num.SouthernEurope,territory.num.EasternEurope) = 1;
movesMatrix(territory.num.SouthernEurope,territory.num.MiddleEast) = 1;
movesMatrix(territory.num.SouthernEurope,territory.num.Egypt) = 1;
movesMatrix(territory.num.SouthernEurope,territory.num.NorthernAfrica) = 1;
movesMatrix(territory.num.SouthernEurope,territory.num.WesternEurope) = 1;
% 21
movesMatrix(territory.num.NorthernAfrica,territory.num.WesternEurope) = 1;
movesMatrix(territory.num.NorthernAfrica,territory.num.SouthernEurope) = 1;
movesMatrix(territory.num.NorthernAfrica,territory.num.Egypt) = 1;
movesMatrix(territory.num.NorthernAfrica,territory.num.EastAfrica) = 1;
movesMatrix(territory.num.NorthernAfrica,territory.num.Congo) = 1;
movesMatrix(territory.num.NorthernAfrica,territory.num.Brasil) = 1;
% 22
movesMatrix(territory.num.Egypt,territory.num.SouthernEurope) = 1;
movesMatrix(territory.num.Egypt,territory.num.MiddleEast) = 1;
movesMatrix(territory.num.Egypt,territory.num.EastAfrica) = 1;
movesMatrix(territory.num.Egypt,territory.num.NorthernAfrica) = 1;
% 23
movesMatrix(territory.num.Congo,territory.num.NorthernAfrica) = 1;
movesMatrix(territory.num.Congo,territory.num.EastAfrica) = 1;
movesMatrix(territory.num.Congo,territory.num.SouthAfrica) = 1;
% 24
movesMatrix(territory.num.EastAfrica,territory.num.NorthernAfrica) = 1;
movesMatrix(territory.num.EastAfrica,territory.num.Egypt) = 1;
movesMatrix(territory.num.EastAfrica,territory.num.MiddleEast) = 1;
movesMatrix(territory.num.EastAfrica,territory.num.Madagascar) = 1;
movesMatrix(territory.num.EastAfrica,territory.num.SouthAfrica) = 1;
movesMatrix(territory.num.EastAfrica,territory.num.Congo) = 1;
% 25
movesMatrix(territory.num.SouthAfrica,territory.num.Congo) = 1;
movesMatrix(territory.num.SouthAfrica,territory.num.EastAfrica) = 1;
movesMatrix(territory.num.SouthAfrica,territory.num.Madagascar) = 1;
% 26
movesMatrix(territory.num.Madagascar,territory.num.SouthAfrica) = 1;
movesMatrix(territory.num.Madagascar,territory.num.EastAfrica) = 1;
% 27
movesMatrix(territory.num.MiddleEast,territory.num.EasternEurope) = 1;
movesMatrix(territory.num.MiddleEast,territory.num.Afghanistan) = 1;
movesMatrix(territory.num.MiddleEast,territory.num.India) = 1;
movesMatrix(territory.num.MiddleEast,territory.num.Egypt) = 1;
movesMatrix(territory.num.MiddleEast,territory.num.EastAfrica) = 1;
movesMatrix(territory.num.MiddleEast,territory.num.SouthernEurope) = 1;
% 28
movesMatrix(territory.num.Afghanistan,territory.num.EasternEurope) = 1;
movesMatrix(territory.num.Afghanistan,territory.num.Ural) = 1;
movesMatrix(territory.num.Afghanistan,territory.num.China) = 1;
movesMatrix(territory.num.Afghanistan,territory.num.India) = 1;
movesMatrix(territory.num.Afghanistan,territory.num.MiddleEast) = 1;
% 29
movesMatrix(territory.num.India,territory.num.Afghanistan) = 1;
movesMatrix(territory.num.India,territory.num.China) = 1;
movesMatrix(territory.num.India,territory.num.Cyam) = 1;
movesMatrix(territory.num.India,territory.num.MiddleEast) = 1;
% 30
movesMatrix(territory.num.Cyam,territory.num.China) = 1;
movesMatrix(territory.num.Cyam,territory.num.Indonesia) = 1;
movesMatrix(territory.num.Cyam,territory.num.India) = 1;
% 31
movesMatrix(territory.num.China,territory.num.Mongolia) = 1;
movesMatrix(territory.num.China,territory.num.Syberia) = 1;
movesMatrix(territory.num.China,territory.num.Cyam) = 1;
movesMatrix(territory.num.China,territory.num.India) = 1;
movesMatrix(territory.num.China,territory.num.Afghanistan) = 1;
movesMatrix(territory.num.China,territory.num.Ural) = 1;
% 32
movesMatrix(territory.num.Mongolia,territory.num.Buratia) = 1;
movesMatrix(territory.num.Mongolia,territory.num.Kamchatka) = 1;
movesMatrix(territory.num.Mongolia,territory.num.Japan) = 1;
movesMatrix(territory.num.Mongolia,territory.num.China) = 1;
movesMatrix(territory.num.Mongolia,territory.num.Syberia) = 1;
% 33
movesMatrix(territory.num.Japan,territory.num.Kamchatka) = 1;
movesMatrix(territory.num.Japan,territory.num.Mongolia) = 1;
% 34
movesMatrix(territory.num.Buratia,territory.num.Yakut) = 1;
movesMatrix(territory.num.Buratia,territory.num.Kamchatka) = 1;
movesMatrix(territory.num.Buratia,territory.num.Mongolia) = 1;
movesMatrix(territory.num.Buratia,territory.num.Syberia) = 1;
% 35
movesMatrix(territory.num.Ural,territory.num.Syberia) = 1;
movesMatrix(territory.num.Ural,territory.num.China) = 1;
movesMatrix(territory.num.Ural,territory.num.Afghanistan) = 1;
movesMatrix(territory.num.Ural,territory.num.EasternEurope) = 1;
% 36
movesMatrix(territory.num.Syberia,territory.num.Yakut) = 1;
movesMatrix(territory.num.Syberia,territory.num.Buratia) = 1;
movesMatrix(territory.num.Syberia,territory.num.Mongolia) = 1;
movesMatrix(territory.num.Syberia,territory.num.China) = 1;
movesMatrix(territory.num.Syberia,territory.num.Ural) = 1;
% 37
movesMatrix(territory.num.Yakut,territory.num.Kamchatka) = 1;
movesMatrix(territory.num.Yakut,territory.num.Buratia) = 1;
movesMatrix(territory.num.Yakut,territory.num.Syberia) = 1;
% 38
movesMatrix(territory.num.Kamchatka,territory.num.Alaska) = 1;
movesMatrix(territory.num.Kamchatka,territory.num.Yakut) = 1;
movesMatrix(territory.num.Kamchatka,territory.num.Japan) = 1;
movesMatrix(territory.num.Kamchatka,territory.num.Buratia) = 1;
movesMatrix(territory.num.Kamchatka,territory.num.Mongolia) = 1;
% 39
movesMatrix(territory.num.Indonesia,territory.num.Cyam) = 1;
movesMatrix(territory.num.Indonesia,territory.num.NewGuinea) = 1;
movesMatrix(territory.num.Indonesia,territory.num.WesternAustralia) = 1;
% 40
movesMatrix(territory.num.NewGuinea,territory.num.Indonesia) = 1;
movesMatrix(territory.num.NewGuinea,territory.num.WesternAustralia) = 1;
movesMatrix(territory.num.NewGuinea,territory.num.EasternAustralia) = 1;
% 41
movesMatrix(territory.num.WesternAustralia,territory.num.Indonesia) = 1;
movesMatrix(territory.num.WesternAustralia,territory.num.NewGuinea) = 1;
movesMatrix(territory.num.WesternAustralia,territory.num.EasternAustralia) = 1;
% 42
movesMatrix(territory.num.EasternAustralia,territory.num.WesternAustralia) = 1;
movesMatrix(territory.num.EasternAustralia,territory.num.NewGuinea) = 1;