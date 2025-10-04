///| WASM-4 卡带入口模块
///| 提供生命游戏卡带入口（初始化与每帧更新）

///| 初始化（被 WASM-4 作为 start 导出调用）
pub fn cartridge_start() -> Unit {
  // 设置调色板：背景 / 网格 / 细胞 / 文本
  @wasm4.set_palette(1, @wasm4.rgb(0x0f0f1a))  // 背景
  @wasm4.set_palette(2, @wasm4.rgb(0x2f7fd5))  // 网格线
  @wasm4.set_palette(3, @wasm4.rgb(0xf5d76e))  // 存活细胞
  @wasm4.set_palette(4, @wasm4.rgb(0xffffff))  // 文本

  // 初始化游戏状态（清空棋盘、重置计数）
  init_state()
  // Debug 信息
  @wasm4.trace("生命游戏已就绪：鼠标绘制，空格开始/暂停")
}

///| 每帧更新（60FPS，由 WASM-4 调用）
pub fn cartridge_upd() -> Unit {
  let gamepad = @wasm4.get_gamepad()
  let mouse = @wasm4.get_mouse()

  handle_gamepad(gamepad)
  handle_mouse(mouse)
  update_simulation()
  render(mouse)
}
