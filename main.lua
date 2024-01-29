tela = {
    LARGURA_TELA = 320,
    ALTURA_TELA = 480,
    MAX_METEOROS = 12
}
aviao = {
    src = "imagens/14bis.png",
    largura = 64,
    altura = 64,
    x = (tela.LARGURA_TELA - 64)/2,
    y = tela.ALTURA_TELA - 64/2,
    tiros = {}
}

METEOROS_ATINGIDOS = 0

meteoros = {}

function objConcluido()
    if METEOROS_ATINGIDOS >= 10 then
        VENCEDOR = true
        musica_ambiente:stop()
        musicaVencedor:play()
    end
end

function atirar()
    musica_tiro:play()
    local tiro = {
        x = aviao.x + (aviao.largura / 2),
        y = aviao.y,
        largura = 16,
        altura = 16
    }
    table.insert(aviao.tiros, tiro)
end

function moveTiros()
    for i = #aviao.tiros, 1, -1 do
        if aviao.tiros[i].y > 0 then
            aviao.tiros[i].y = aviao.tiros[i].y - 1
        else
             table.remove(aviao.tiros, i)
        end
    end
end

function destroiAviao()
    musica_ambiente:stop()
    musica_destroi:play()
    aviao.src = "imagens/explosao_nave.png"
    aviao.imagem = love.graphics.newImage(aviao.src)
    aviao.largura = 55
    aviao.altura = 63
end

function trocaMusica()
    musica_ambiente:stop()
    game_over:play()
end

function checkColisao()
    for k, meteoro in pairs(meteoros) do
        if testaColisao(meteoro.x, meteoro.y, meteoro.largura, meteoro.altura, aviao.x, aviao.y, aviao.largura, aviao.altura) then
            trocaMusica()
            destroiAviao()
            FIM_DE_JOGO = true
        end
    end

    for i = #aviao.tiros, 1, -1 do
        for j = #meteoros, 1, -1 do
            if testaColisao(aviao.tiros[i].x, aviao.tiros[i].y, aviao.tiros[i].largura, aviao.tiros[i].altura,
            meteoros[j].x, meteoros[j].y, meteoros[j].largura, meteoros[j].altura) then
                METEOROS_ATINGIDOS = METEOROS_ATINGIDOS + 1
                table.remove(aviao.tiros, i)
                table.remove(meteoros, j)
                break
            end
        end
    end
end

function testaColisao(X1, Y1, L1, A1, X2, Y2, L2, A2)
    return X2 < X1 + L1 and
    X1 < X2 + L2 and
    Y1 < Y2 + A2 and
    Y2 < Y1 + A1
end

function removeMeteoros()
    for i = #meteoros, 1, -1 do
        if meteoros[i].y > tela.ALTURA_TELA then
            table.remove(meteoros, i)
        end
    end
end

function move_aviao()
    if love.keyboard.isDown('w') then
        aviao.y = aviao.y-1
    end
    if love.keyboard.isDown('a') then
        aviao.x = aviao.x-1
    end
    if love.keyboard.isDown('s') then
        aviao.y = aviao.y+1
    end
    if love.keyboard.isDown('d') then
        aviao.x = aviao.x+1
    end
end

function cria_meteoro()
    meteoro = {
        x = math.random(tela.LARGURA_TELA),
        y = -70,
        peso = math.random(3),
        deslocamento_horizontal = math.random(-1,1),
        largura = 50,
        altura = 44,
    }
    table.insert(meteoros, meteoro)
end

function moveMeteoro()
    for k, meteoro in pairs(meteoros) do
        meteoro.y = meteoro.y + meteoro.peso
        meteoro.x = meteoro.x + meteoro.deslocamento_horizontal
    end
end

function love.load()
    love.window.setMode(tela.LARGURA_TELA, tela.ALTURA_TELA, {resizable = false})
    love.window.setTitle("Pokegame")
    math.randomseed(os.time())

    background = love.graphics.newImage("imagens/background.png")
    aviao.imagem = love.graphics.newImage(aviao.src)
    meteoro_img = love.graphics.newImage("imagens/meteoro.png")
    tiro_img  = love.graphics.newImage("imagens/tiro.png")
    game_over_img= love.graphics.newImage("imagens/gameover.png")
    vencedor_img = love.graphics.newImage("imagens/vencedor.png")

    musica_ambiente = love.audio.newSource("audios/ambiente.wav", "stream")
    musica_ambiente:setLooping(true)
    musica_ambiente:play()
    musica_tiro = love.audio.newSource("audios/disparo.wav", "static")

    musica_destroi = love.audio.newSource("audios/destruicao.wav", "stream")
    game_over = love.audio.newSource("audios/game_over.wav", "stream")
    musicaVencedor = love.audio.newSource("audios/winner.wav", "static")

end

function love.keypressed(tecla)
    if tecla == 'escape' then
        love.event.quit()
    elseif tecla == 'space' then
        atirar()
    end
end

function love.update(dt)
    if not FIM_DE_JOGO and not VENCEDOR then
        if love.keyboard.isDown('w','a','s','d') then
            move_aviao()
        end
        removeMeteoros()
        if #meteoros < tela.MAX_METEOROS then
            cria_meteoro()
        end
        moveMeteoro()
        moveTiros()
        checkColisao()
        objConcluido()
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(aviao.imagem, aviao.x, aviao.y)

    love.graphics.print("Meteoros restantes: "..10 - METEOROS_ATINGIDOS, 0, 0)

    for i, meteoro in pairs(meteoros) do
        love.graphics.draw(meteoro_img, meteoro.x, meteoro.y)
    end

    for k, tiro in pairs(aviao.tiros) do
        love.graphics.draw(tiro_img, tiro.x, tiro.y)
    end

    if FIM_DE_JOGO then
        love.graphics.draw(game_over_img, (tela.LARGURA_TELA - game_over_img:getWidth()) / 2, (tela.ALTURA_TELA - game_over_img:getHeight()) / 2)
    end

    if VENCEDOR then
        love.graphics.draw(vencedor_img, (tela.LARGURA_TELA - vencedor_img:getWidth()) / 2, (tela.ALTURA_TELA - vencedor_img:getHeight()) / 2)
    end
end