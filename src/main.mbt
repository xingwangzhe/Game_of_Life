///| 主导出入口文件（WASM-4 期望的 start / upd 绑定）
///| 将调用委托给下列功能模块：
///| - cartridge.mbt：启动 & 每帧驱动
///| - game_of_life.mbt：生命游戏核心算法
///| - game_state.mbt：运行期全局可变状态
///| - constants.mbt：常量与布局配置
///| - input_handler.mbt：输入分发处理
///| - renderer.mbt：渲染绘制逻辑
///| - simulation.mbt：演化与帧节流

///| 初始化（被导出为 start）
pub fn start() -> Unit {
  cartridge_start()
}

///| 每帧更新（被导出为 upd -> update）
pub fn upd() -> Unit {
  cartridge_upd()
}

