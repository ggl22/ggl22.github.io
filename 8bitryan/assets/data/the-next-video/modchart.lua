--1.74secs per section
--0.87secs per section/2
--0.43secs per section/4
--0.10secs per section/16

local fading = false 
local faded = false 

local sway = false 
local swayIntenseCentre = false 
local swayIntenserCentre = false 

local waitForBeatFade = false 
local waitForBeatCam = false 
local waitForStepCam = false 

local camera1 = false 
local camera2 = false 
local camera3 = false 
local camera4 = false
local lockzoom = false 

function setDefault(id)
	_G['defaultStrum'..id..'X'] = getActorX(id)
end

function update (elapsed)
local currentBeat = (songPos / 1000)*(bpm/60)
    if lockzoom then 
        setCamZoom(1.25)
    end
    if fading then 
        if curBeat % 4 == 0 and not waitForBeatFade then 
            waitForBeatFade = true 
            faded = not faded 
            if faded then 
                for i = 0, 7 do 
                    tweenFadeOut(i, 1, 1.74)
                end
            else 
                for i = 0, 7 do 
                    tweenFadeIn(i, 0.1, 1.74)
                end
            end
        end
    end
    if sway then 
        for i = 0, 7 do 
            setActorX(_G['defaultStrum'..i..'X'] + 16 * math.sin((currentBeat + i*0)), i)
            setActorY(_G['defaultStrum'..i..'Y'],i)
        end 
    end
    if swayIntenseCentre then 
        for i = 0, 3 do 
            setActorX(_G['defaultStrum'..i..'X'] + 320 * math.sin((currentBeat + i*0)), i)
            setActorY(_G['defaultStrum'..i..'Y'] + 16 * math.cos((currentBeat + i*32) * math.pi),i)
        end 
        for i = 4, 7 do 
            setActorX(_G['defaultStrum'..i..'X'] - 320 * math.sin((currentBeat + i*0)), i)
            setActorY(_G['defaultStrum'..i..'Y'] + 16 * math.cos((currentBeat + i*32) * math.pi),i)
        end 
    end
    if swayIntenserCentre then 
        for i = 0, 3 do 
            setActorX(_G['defaultStrum'..i..'X'] + 320 * math.sin((currentBeat + i*0)), i)
            setActorY(_G['defaultStrum'..i..'Y'] + 48 * math.cos((currentBeat + i*32) * math.pi),i)
        end 
        for i = 4, 7 do 
            setActorX(_G['defaultStrum'..i..'X'] - 320 * math.sin((currentBeat + i*0)), i)
            setActorY(_G['defaultStrum'..i..'Y'] + 48 * math.cos((currentBeat + i*32) * math.pi),i)
        end 
    end
    if camera1 then 
        if curBeat % 1 == 0 and not waitForBeatCam then 
            waitForBeatCam = true 
            setCamZoom(1.05)
        end
    end
    if camera2 then 
        if curBeat % 1 == 0 and not waitForBeatCam then 
            waitForBeatCam = true 
            setCamZoom(1.15)
        end
    end
    if camera3 then 
        if curStep % 2 == 0 and not waitForStepCam then 
            waitForStepCam = true 
            setCamZoom(1.15)
        end
    end
    if camera4 then 
        if curStep % 1 == 0 and not waitForStepCam then 
            waitForStepCam = true 
            setCamZoom(1.15)
        end
    end
end

function beatHit (beat)
    waitForBeatFade = false 
    waitForBeatCam = false 
end

function stepHit (step)
    waitForStepCam = false 
    if step == 1 then 
        fading = true 
    end
    if step == 128 then 
        setCamZoom(1.15)
        camera1 = true 
    end
    if step == 240 then 
        camera1 = false 
        fading = false 
        for i = 0, 7 do 
            tweenFadeOut(i, 1, 1.74)
        end
    end
    if step == 256 then 
        sway = true 
        setCamZoom(1.2)
        camera2 = true 
    end
    if step == 320 then 
        setCamZoom(1.2)
        camera2 = false 
        camera3 = true 
    end
    if step == 352 then 
        setCamZoom(1.2)
        camera3 = false 
        camera4 = true 
    end
    if step == 368 then 
        camera4 = false 
        sway = false 
        for i = 0, 7 do 
            tweenFadeIn(i, 0, 0.43)
        end
    end
    if step == 374 then 
        tweenCameraZoom(1.25, 0.20, i)
    end
    if step == 376 then 
        lockzoom = true 
        for i = 0, 3 do 
            tweenPosXAngle(i, _G['defaultStrum'..i..'X'] + 320,getActorAngle(i), 0.001, 'setDefault')
        end
        for i = 4, 7 do 
            tweenPosXAngle(i, _G['defaultStrum'..i..'X'] - 320,getActorAngle(i), 0.001, 'setDefault')
        end
    end
    if step == 380 then 
        for i = 0, 3 do 
            tweenFadeOut(i, 1, 0.43)
        end
    end
    if step == 383 then 
        lockzoom = false 
    end
-- Tweens 
    for i = 0, 3 do 
        -- left 
        if step == 390 or step == 396 or step == 410 or step == 440
        or step == 460 or step == 463 or step == 476 or step == 490 then 
            tweenPosXAngle(i, _G['defaultStrum'..i..'X'] - 40,getActorAngle(i), 0.10, i)
        end
        -- down 
        if step == 392 or step == 395 or step == 398 or step == 400
        or step == 428 or step == 432 or step == 443 or step == 451
        or step == 458 or step == 462 or step == 478 then 
            tweenPosYAngle(i, _G['defaultStrum'..i..'Y'] + 40,getActorAngle(i), 0.10, i)
        end
        -- up 
        if step == 384 or step == 393 or step == 399 or step == 406
        or step == 419 or step == 429 or step == 448 or step == 454
        or step == 457 or step == 459 or step == 464 or step == 486 then 
            tweenPosYAngle(i, _G['defaultStrum'..i..'Y'] - 40,getActorAngle(i), 0.10, i)
        end
        -- right 
        if step == 387 or step == 394 or step == 397 or step == 408
        or step == 423 or step == 446 or step == 456 or step == 461
        or step == 470 or step == 480 or step == 494 then 
            tweenPosXAngle(i, _G['defaultStrum'..i..'X'] + 40,getActorAngle(i), 0.10, i)
        end
    end
-- Back
    if step == 496 then
        for i = 0, 3 do 
            tweenPosXAngle(i, _G['defaultStrum'..i..'X'],getActorAngle(i), 0.43, i)
            tweenPosYAngle(i, _G['defaultStrum'..i..'Y'],getActorAngle(i), 0.43, i)
        end
    end
    if step == 504 then
        for i = 0, 3 do 
            tweenFadeIn(i, 0, 0.43)
        end
        for i = 4, 7 do 
            tweenFadeOut(i, 1, 0.43)
        end
        tweenPosXAngle(0, _G['defaultStrum0X'] - 320,getActorAngle(0) - 360, 0.87, i)
        tweenPosXAngle(1, _G['defaultStrum1X'] - 260,getActorAngle(1) - 360, 0.87, i)
        tweenPosXAngle(2, _G['defaultStrum2X'] + 260,getActorAngle(2) + 360, 0.87, i)
        tweenPosXAngle(3, _G['defaultStrum3X'] + 320,getActorAngle(3) + 360, 0.87, i)
    end 
    if step == 620 then 
        for i = 0, 3 do 
            tweenFadeIn(i, 1, 1.74)
        end
    end
    if step == 628 then 
        for i = 4, 7 do 
            tweenPosXAngle(i, _G['defaultStrum'..i..'X'],getActorAngle(i), 0.43, i)
            tweenPosYAngle(i, _G['defaultStrum'..i..'Y'],getActorAngle(i), 0.43, i)
        end
    end
    if step == 636 then 
        for i = 4, 7 do 
            tweenFadeIn(i, 0, 0.43)
        end
        tweenPosXAngle(0, _G['defaultStrum0X'],getActorAngle(0) + 360, 0.43, i)
        tweenPosXAngle(1, _G['defaultStrum1X'],getActorAngle(1) + 360, 0.43, i)
        tweenPosXAngle(2, _G['defaultStrum2X'],getActorAngle(2) - 360, 0.43, i)
        tweenPosXAngle(3, _G['defaultStrum3X'],getActorAngle(3) - 360, 0.43, i)
    end
    if step == 640 then 
        swayIntenseCentre = true 
    end
    if step == 696 then 
        for i = 0, 3 do 
            tweenFadeIn(i, 0, 0.87)
        end
        for i = 4, 7 do 
            tweenFadeOut(i, 1, 0.87)
        end
    end
    if step == 760 then 
        for i = 0, 3 do 
            tweenFadeOut(i, 1, 0.87)
        end
    end
    if step == 764 then 
        for i = 4, 7 do 
            tweenPosXAngle(i, _G['defaultStrum'..i..'X'],getActorAngle(i), 0.43, i)
            tweenPosYAngle(i, _G['defaultStrum'..i..'Y'],getActorAngle(i), 0.43, i)
        end
    end
    if step == 768 then 
        swayIntenseCentre = false 
        swayIntenserCentre = true 
        fading = true 
    end
    if step == 896 then 
        for i = 0, 7 do 
            tweenFadeIn(i, 0, 0.43)
        end
        fading = false 
    end
-- Camera Works 
    if step == 384 or step == 392 or step == 408 or step == 424
    or step == 440 or step == 456 or step == 472 or step == 488
    or step == 504 or step == 512 or step == 520 or step == 536
    or step == 552 or step == 568 or step == 584 or step == 600
    or step == 616 or step == 632 or step == 640 or step == 648
    or step == 664 or step == 680 or step == 696 or step == 704
    or step == 712 or step == 728 or step == 744 or step == 760
    or step == 768 or step == 776 or step == 792 or step == 808
    or step == 824 or step == 832 or step == 840 or step == 856
    or step == 872 then 
        setCamZoom(1.15)
    end
    if step == 400 or step == 416 or step == 432 or step == 436
    or step == 448 or step == 464 or step == 480 or step == 496
    or step == 500 or step == 528 or step == 544 or step == 560
    or step == 564 or step == 576 or step == 592 or step == 608
    or step == 624 or step == 628 or step == 636 or step == 656
    or step == 672 or step == 688 or step == 692 or step == 720
    or step == 736 or step == 752 or step == 756 or step == 764 
    or step == 784 or step == 800 or step == 816 or step == 820 
    or step == 848 or step == 864 or step == 880 or step == 884 then 
        setCamZoom(1.1)
    end
    if step == 407 or step == 471 or step == 535 or step == 598
    or step == 599 or step == 663 or step == 727 or step == 791
    or step == 854 or step == 855 or step == 888 or step == 892 then 
        setCamZoom(1.05)
    end
end

function keyPressed (key)
    if curStep >= 512 and curStep < 628 then 
        if key == 'left' then 
            for i = 4, 7 do 
                tweenPosXAngle(i, _G['defaultStrum'..i..'X'] - 40, getActorAngle(i), 0.10, i)
            end
        end
        if key == 'down' then 
            for i = 4, 7 do 
                tweenPosYAngle(i, _G['defaultStrum'..i..'Y'] + 40, getActorAngle(i), 0.10, i)
            end
        end
        if key == 'up' then 
            for i = 4, 7 do 
                tweenPosYAngle(i, _G['defaultStrum'..i..'Y'] - 40, getActorAngle(i), 0.10, i)
            end
        end
        if key == 'right' then 
            for i = 4, 7 do 
                tweenPosXAngle(i, _G['defaultStrum'..i..'X'] + 40, getActorAngle(i), 0.10, i)
            end
        end
    end
end