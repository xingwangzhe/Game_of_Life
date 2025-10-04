///| 全局状态模块
///| 管理运行中可变引用（是否运行 / 代数 / 拖拽状态等）

///| 主模拟实例（棋盘 + 双缓冲）
pub let game : GameOfLife = GameOfLife::new(board_cols, board_rows)

///| 模拟控制变量
pub let is_running : Ref[Bool] = { val: false }
pub let generation : Ref[Int] = { val: 0 }
pub let tick_counter : Ref[Int] = { val: 0 }

///| 输入追踪（上一帧按键 / 鼠标拖拽状态）
pub let prev_gamepad : Ref[@wasm4.GamePad] = { val: @wasm4.GamePad::default() }
pub let mouse_dragging : Ref[Bool] = { val: false }
pub let drag_value : Ref[Bool] = { val: false }
pub let last_cell_x : Ref[Int] = { val: -1 }
pub let last_cell_y : Ref[Int] = { val: -1 }

///| 初始化（重置控制变量并清空棋盘）
pub fn init_state() -> Unit {
  is_running.val = false
  generation.val = 0
  tick_counter.val = 0
  mouse_dragging.val = false
  drag_value.val = false
  last_cell_x.val = -1
  last_cell_y.val = -1
  game.clear()
}

///| 结束一次拖拽（鼠标抬起或离开区间）
pub fn reset_drag_state() -> Unit {
  mouse_dragging.val = false
  drag_value.val = false
  last_cell_x.val = -1
  last_cell_y.val = -1
}

///| 判断鼠标所指细胞是否发生变化（避免重复写入）
pub fn has_cell_changed(x : Int, y : Int) -> Bool {
  last_cell_x.val != x || last_cell_y.val != y
}
