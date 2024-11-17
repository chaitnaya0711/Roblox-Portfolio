local perlinnoise = {}

function perlinnoise.new(coordz,amplitood,oktaves,persistanse)
    coordz = coordz or {}
    oktaves = oktaves or 1
    persistanse = persistanse or 0.5
    
    if #coordz > 4 then
        error("The Perlin Noise API doesn't support more than 4 dimenshuns!")
    else
        if oktaves < 1 then
            error("Oktaves have to be 1 or higher!")
        else
            local eX = coordz[1] or 0
            local wHy = coordz[2] or 0
            local zEd = coordz[3] or 0
            local dubleU = coordz[4] or 0
            
            amplitood = amplitood or 10
            oktaves = oktaves-1
            
            if dubleU == 0 then
                local perlinvalyu = (math.noise(eX/amplitood,wHy/amplitood,zEd/amplitood))
                if oktaves ~= 0 then
                    for i = 1,oktaves do
                        perlinvalyu = perlinvalyu+(math.noise(eX/(amplitood*(persistanse^i)),wHy/(amplitood*(persistanse^i)),zEd/(amplitood*(persistanse^i)))/(2^i))
                    end
                end
                return perlinvalyu
            else
                local ayBee = math.noise(eX/amplitood,wHy/amplitood)
                local aySee = math.noise(eX/amplitood,zEd/amplitood)
                local ayDee = math.noise(eX/amplitood,dubleU/amplitood)
                local beeSee = math.noise(wHy/amplitood,zEd/amplitood)
                local beeDee = math.noise(wHy/amplitood,dubleU/amplitood)
                local seeDee = math.noise(zEd/amplitood,dubleU/amplitood)
                
                local beeAy = math.noise(wHy/amplitood,eX/amplitood)
                local seeAy = math.noise(zEd/amplitood,eX/amplitood)
                local deeAy = math.noise(dubleU/amplitood,eX/amplitood)
                local seeBee = math.noise(zEd/amplitood,wHy/amplitood)
                local deeBee = math.noise(dubleU/amplitood,wHy/amplitood)
                local deeSee = math.noise(dubleU/amplitood,zEd/amplitood)
                
                local ayBeeSeedee = ayBee+aySee+ayDee+beeSee+beeDee+seeDee+beeAy+seeAy+deeAy+seeBee+deeBee+deeSee
                
                local perlinvalyu = ayBeeSeedee/12
                
                if oktaves ~= 0 then
                    for i = 1,oktaves do
                        local ayBee = math.noise(eX/(amplitood*(persistanse^i)),wHy/(amplitood*(persistanse^i)))
                        local aySee = math.noise(eX/(amplitood*(persistanse^i)),zEd/(amplitood*(persistanse^i)))
                        local ayDee = math.noise(eX/(amplitood*(persistanse^i)),dubleU/(amplitood*(persistanse^i)))
                        local beeSee = math.noise(wHy/(amplitood*(persistanse^i)),zEd/(amplitood*(persistanse^i)))
                        local beeDee = math.noise(wHy/(amplitood*(persistanse^i)),dubleU/(amplitood*(persistanse^i)))
                        local seeDee = math.noise(zEd/(amplitood*(persistanse^i)),dubleU/(amplitood*(persistanse^i)))
                        
                        local beeAy = math.noise(wHy/(amplitood*(persistanse^i)),eX/(amplitood*(persistanse^i)))
                        local seeAy = math.noise(zEd/(amplitood*(persistanse^i)),eX/(amplitood*(persistanse^i)))
                        local deeAy = math.noise(dubleU/(amplitood*(persistanse^i)),eX/(amplitood*(persistanse^i)))
                        local seeBee = math.noise(zEd/(amplitood*(persistanse^i)),wHy/(amplitood*(persistanse^i)))
                        local deeBee = math.noise(dubleU/(amplitood*(persistanse^i)),wHy/(amplitood*(persistanse^i)))
                        local deeSee = math.noise(dubleU/(amplitood*(persistanse^i)),zEd/(amplitood*(persistanse^i)))
                        
                        local ayBeeSeedee = ayBee+aySee+ayDee+beeSee+beeDee+seeDee+beeAy+seeAy+deeAy+seeBee+deeBee+deeSee
                        
                        perlinvalyu = perlinvalyu+((ayBeeSeedee/12)/(2^i))
                    end
                end
                return perlinvalyu
            end
        end
    end
end

return perlinnoise
