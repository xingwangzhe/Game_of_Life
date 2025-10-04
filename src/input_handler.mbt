///| 输入处理模块
///| 负责手柄/键盘/鼠标的事件解析与状态修改

///| 处理手柄/键盘输入（按钮：开始/暂停 / 清空）
pub fn handle_gamepad(gamepad : @wasm4.GamePad) -> Unit {
  let was_pressed = prev_gamepad.val
  // 按键1：切换运行/暂停（对应空格/X）
  if gamepad.button_1 && not(was_pressed.button_1) {
    is_running.val = not(is_running.val)
  }
  // 按键2：清空棋盘并复位
  if gamepad.button_2 && not(was_pressed.button_2) {
    game.clear()
    generation.val = 0
    tick_counter.val = 0
    is_running.val = false
  }
  prev_gamepad.val = gamepad
}

///| 处理鼠标输入：在暂停状态下可编辑棋盘
pub fn handle_mouse(mouse : @wasm4.Mouse) -> Unit {
  // 直接使用整个 160x160 棋盘，无面板阻挡

  // 运行中仍允许 hover 但不写入
  if is_running.val {
    reset_drag_state()
    return
  }

  let board_x = mouse.x - board_origin_x
  let board_y = mouse.y - board_origin_y
  let inside = board_x >= 0 && board_x < board_pixels && 
               board_y >= 0 && board_y < board_pixels

  let pressed = mouse.left || mouse.right
  if pressed && inside {
    handle_mouse_drag(mouse, board_x, board_y)
  } else if not(pressed) {
    reset_drag_state()
  }
}

///| 处理拖拽绘制/擦除（左键绘制/翻转，右键擦除）
fn handle_mouse_drag(mouse : @wasm4.Mouse, board_x : Int, board_y : Int) -> Unit {
  let cell_x = board_x / cell_size
  let cell_y = board_y / cell_size
  let existing = game.get_cell(cell_x, cell_y)
  
  // 计算目标状态
  let target = if mouse.right {
  false  // 右键永远设为死亡
  } else if mouse_dragging.val {
  drag_value.val  // 拖动中保持首次确定的值
  } else {
  not(existing)  // 首次点击：对当前状态取反
  }

  // 更新鼠标所指细胞缓存
  if has_cell_changed(cell_x, cell_y) {
    last_cell_x.val = cell_x
    last_cell_y.val = cell_y
  }

  // 首次进入拖拽：锁定拖拽写入值
  if not(mouse_dragging.val) {
    drag_value.val = target
  }

  mouse_dragging.val = true
  
  // 实际写入更改
  if existing != target {
    game.set_cell(cell_x, cell_y, target)
  }
}

///| 处理右侧按钮点击（返回是否消费事件）
