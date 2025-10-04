///| 渲染模块
///| 负责背景/网格/细胞/悬停高亮的绘制（已移除文字 HUD）

///| 主渲染入口（按顺序调用各子绘制函数）
pub fn render(mouse : @wasm4.Mouse) -> Unit {
  draw_background()
  draw_grid()
  draw_cells()
  draw_hover(mouse)
}

///| 绘制背景填充
fn draw_background() -> Unit {
  @wasm4.set_draw_colors(1, index=1)
  @wasm4.set_draw_colors(0, index=2)
  @wasm4.set_draw_colors(0, index=3)
  @wasm4.set_draw_colors(0, index=4)
  @wasm4.rect(0, 0, 160, 160)
}

///| 绘制网格线
fn draw_grid() -> Unit {
  @wasm4.set_draw_colors(2, index=1)
  @wasm4.set_draw_colors(0, index=2)
  @wasm4.set_draw_colors(0, index=3)
  @wasm4.set_draw_colors(0, index=4)
  
  // 垂直线
  for x = 0; x <= board_cols; x = x + 1 {
    let screen_x = board_origin_x + x * cell_size
    if screen_x <= 159 { // 避免越界 160
      @wasm4.vline(screen_x, board_origin_y, board_pixels)
    }
  }
  
  // 水平线
  for y = 0; y <= board_rows; y = y + 1 {
    let screen_y = board_origin_y + y * cell_size
    if screen_y <= 159 {
      @wasm4.hline(board_origin_x, screen_y, board_pixels)
    }
  }
}

///| 绘制存活细胞
fn draw_cells() -> Unit {
  @wasm4.set_draw_colors(3, index=1)
  @wasm4.set_draw_colors(0, index=2)
  @wasm4.set_draw_colors(0, index=3)
  @wasm4.set_draw_colors(0, index=4)
  
  let width = game.get_width()
  let height = game.get_height()
  
  for y = 0; y < height; y = y + 1 {
    for x = 0; x < width; x = x + 1 {
      if game.get_cell(x, y) {
        let sx = board_origin_x + x * cell_size + 1
        let sy = board_origin_y + y * cell_size + 1
        @wasm4.rect(sx, sy, cell_size - 1, cell_size - 1)
      }
    }
  }
}

///| 暂停时绘制鼠标悬停框（仅边框）
fn draw_hover(mouse : @wasm4.Mouse) -> Unit {
  if is_running.val {
    return
  }
  
  let board_x = mouse.x - board_origin_x
  let board_y = mouse.y - board_origin_y
  
  // 边界判定
  if board_x < 0 || board_x >= board_pixels || 
     board_y < 0 || board_y >= board_pixels {
    return
  }
  
  let cell_x = board_x / cell_size
  let cell_y = board_y / cell_size
  
  if cell_x < 0 || cell_x >= game.get_width() || 
     cell_y < 0 || cell_y >= game.get_height() {
    return
  }
  
  let sx = board_origin_x + cell_x * cell_size
  let sy = board_origin_y + cell_y * cell_size
  
  @wasm4.set_draw_colors(4, index=1)
  @wasm4.set_draw_colors(0, index=2)
  @wasm4.set_draw_colors(0, index=3)
  @wasm4.set_draw_colors(0, index=4)
  
  // 画矩形边框
  @wasm4.rect(sx, sy, cell_size, 1)
  @wasm4.rect(sx, sy + cell_size - 1, cell_size, 1)
  @wasm4.rect(sx, sy, 1, cell_size)
  @wasm4.rect(sx + cell_size - 1, sy, 1, cell_size)
}

///| 绘制 HUD（状态/世代/操作提示）
// 已移除 HUD：不再绘制任何文字
