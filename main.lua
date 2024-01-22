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
}

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

meteoros = {}

function cria_meteoro()
    meteoro = {
        x = math.random(tela.LARGURA_TELA),
        y = -70,
        peso = math.random(3),
        deslocamento_horizontal = math.random(-1,1)
    }
    table.insert(meteoros, meteoro)
end

function move_meteoro()
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
end

function love.update(dt)
    if love.keyboard.isDown('w','a','s','d') then
        move_aviao()
    end

    removeMeteoros()
    if #meteoros < tela.MAX_METEOROS then
    cria_meteoro()
    end
    move_meteoro()
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(aviao.imagem, aviao.x, aviao.y)

    for i, meteoro in pairs(meteoros) do
        love.graphics.draw(meteoro_img, meteoro.x, meteoro.y)
    end
end