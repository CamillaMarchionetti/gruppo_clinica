function [hs_sx, hs_dx] = estrazione_heel_strikes(Walkway)
   indici_sx = find(diff(Walkway.("L Foot Contact")) == 1);
   indici_dx = find(diff(Walkway.("R Foot Contact")) == 1);
   hs_sx = seconds(Walkway.Time(indici_sx));
   hs_dx = seconds(Walkway.Time(indici_dx));
end
