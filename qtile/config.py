from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
import subprocess
import re

mod = "mod4"
# terminal = guess_terminal()
default_terminal = "alacritty"


@hook.subscribe.startup_once
def autostart():
    subprocess.Popen(["/home/sam/.config/polybar/launch_polybar.sh"])
    subprocess.Popen(["numlockx", "on"])
    # subprocess.Popen(["picom"])
    # subprocess.Popen(["feh", "--bg-fill", "--randomize", "/home/sam/Pictures/*"])


# 定义一个包含多个应用程序窗口类的列表
floating_apps = ['com.xunlei.download']


@hook.subscribe.client_new
def set_floating(window):
    # 使用正则表达式来匹配多个窗口类
    if window.match(Match(wm_class=re.compile(r"^(%s)$" % '|'.join(floating_apps)))):
        window.floating = True  # 设置窗口为浮动模式


keys = [
    # 可绑定到键的可用命令列表可以在以下地址找到
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # 在窗口之间切换
    Key([mod], "j", lazy.layout.next(), desc="Move window focus to other window"),  # 将窗口焦点移动到下一个窗口
    # 在左/右列之间移动窗口，或者在当前堆栈中向上/向下移动。
    # 在 Columns 布局中超出范围移动将创建新列。
    Key([mod, "shift"], "j", lazy.layout.shuffle_left(), desc="Move window to the left"),  # 将窗口移动到左边(diy)
    Key([mod, "shift"], "k", lazy.layout.shuffle_right(), desc="Move window to the right"),  # 将窗口移动到右边(diy)
    # 调整窗口大小。如果当前窗口在屏幕边缘并且方向朝向屏幕边缘，窗口将缩小。
    Key([mod], "h", lazy.layout.grow_left(), desc="Grow window to the left"),  # 向左增加窗口大小
    Key([mod], "l", lazy.layout.grow_right(), desc="Grow window to the right"),  # 向右增加窗口大小
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),  # 重置所有窗口大小
    # 在堆栈的分割和未分割两侧之间切换。
    # Split = 显示所有窗口
    # Unsplit = 显示1个窗口，类似于 Max 布局，但仍然有多个堆栈窗格
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack", ),  # 在堆栈的分割和未分割两侧之间切换
    # Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),  # 启动终端
    Key([mod], "Return", lazy.spawn(default_terminal), desc="Launch terminal"),
    # 切换布局
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),  # 在布局之间切换
    Key([mod, "shift"], "c", lazy.window.kill(), desc="Kill focused window"),  # 关闭焦点所在窗口
    Key([mod], "m", lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window", ),  # 切换焦点窗口的全屏状态
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),  # 切换焦点窗口的浮动状态
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Shutdown Qtile"),  # 关闭 Qtile
    Key([mod], "r", lazy.spawn("rofi -show drun"), desc="启动 Rofi"),  # 启动rofi(diy)
    Key([mod], "Escape", lazy.group.toscreen(toggle=True), desc="Switch to last group"),
]

# 添加切换虚拟终端（VT）的键绑定
# 在默认配置中无法检查 qtile.core.name，因为它在 Qtile 启动之前加载
# 因此我们使用 .when(func=...) 延迟检查，直到键绑定运行时
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],  # 组合键为 Ctrl + Alt
            f"f{vt}",  # 功能键 F1 到 F7
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",  # 描述为切换到 VT
        )
    )

# 定义工作组
# 󰨞
groups = [Group(i) for i in "123456789abdef"]
for i in groups:
    keys.extend(
        [
            # mod + 工作组编号 = 切换到工作组
            Key(
                [mod],
                i.name,  # 工作组名称
                lazy.group[i.name].toscreen(),  # 切换到指定的工作组
                desc="Switch to group {}".format(i.name),  # 描述为切换到工作组
            ),

            # mod + shift + 工作组编号 = 切换到并将焦点窗口移动到工作组
            Key(
                [mod, "shift"],
                i.name,  # 工作组名称
                lazy.window.togroup(i.name, switch_group=True),  # 切换到并移动窗口
                desc="Switch to & move focused window to group {}".format(i.name),  # 描述为切换并移动窗口到工作组
            ),
        ]
    )

# 定义布局
layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),  # 列布局，设置边框颜色和宽度
    layout.Max(),  # 最大化布局
    layout.MonadWide(),  # 单子宽布局
    layout.TreeTab(),  # 树形标签布局
    # 尝试更多布局，取消注释以下布局来启用
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),  # 堆栈布局，两个堆栈
    # layout.VerticalTile(),  # 垂直平铺布局
    # layout.RatioTile(),  # 比例平铺布局
    # layout.MonadTall(),  # 单子高布局
    # layout.Bsp(),  # 二叉空间分割布局
    # layout.Matrix(),   # 矩阵布局
    # layout.Tile(),  # 平铺布局
    # layout.Zoomy(),  # 缩放布局
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()
screens = [
    Screen(),
]
# 拖动浮动布局的窗口
mouse = [
    # 使用 mod 键（通常是超级键或 Windows 键）加上鼠标左键（Button1）拖动窗口以设置浮动窗口的位置
    Drag([mod], "Button1",  # 修饰键和鼠标左键
         lazy.window.set_position_floating(),  # 设置窗口浮动位置
         start=lazy.window.get_position()),  # 获取窗口初始位置
    # 使用 mod 键加上鼠标右键（Button3）拖动窗口以设置浮动窗口的大小
    Drag([mod], "Button3",  # 修饰键和鼠标右键
         lazy.window.set_size_floating(),  # 设置窗口浮动大小
         start=lazy.window.get_size()),  # 获取窗口初始大小
    # 使用 mod 键加上鼠标中键（Button2）点击窗口将其置于最前
    Click([mod], "Button2",  # 修饰键和鼠标中键
          lazy.window.bring_to_front()),  # 将窗口置于最前
]
dgroups_key_binder = None  # 不使用动态工作组的键绑定
dgroups_app_rules = []  # 动态工作组应用规则，默认为空列表
follow_mouse_focus = True  # 当鼠标移动到窗口上时，窗口获得焦点
bring_front_click = False  # 点击窗口不会将其置于最前
# floats_kept_above = True  # 保持浮动窗口在非浮动窗口之上
# cursor_warp = False  # 当切换焦点时，不自动将光标移动到新焦点窗口
floating_layout = layout.Floating(
    float_rules=[
        # 使用 `xprop` 工具查看 X 客户端的 wm class 和 name。
        *layout.Floating.default_float_rules,  # 加载默认的浮动规则
        Match(wm_class="confirmreset"),  # gitk：确认重置窗口
        Match(wm_class="makebranch"),  # gitk：创建分支窗口
        Match(wm_class="maketag"),  # gitk：创建标签窗口
        Match(wm_class="ssh-askpass"),  # ssh-askpass：SSH 密码输入窗口
        Match(title="branchdialog"),  # gitk：分支对话框
        Match(title="pinentry"),  # GPG 密钥密码输入窗口
    ]
)
# auto_fullscreen = True  # 自动将应用程序全屏显示
focus_on_window_activation = "smart"  # 智能窗口激活焦点策略
reconfigure_screens = True  # 重新配置屏幕设置
auto_minimize = True  # 自动最小化
wl_input_rules = None  # Wayland 输入设备规则，默认不配置
wl_xcursor_theme = None  # Wayland 光标主题
wl_xcursor_size = 24  # Wayland 光标大小，单位为像素
wmname = "LG3D"  # 设置窗口管理器名称为 "LG3D"，以解决某些 Java 应用程序的问题
