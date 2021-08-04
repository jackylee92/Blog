## 键盘配置

> HHKB上下左右需要fn+[/;'才行，全都在右手边，太别扭了。

通过Karabiner将上下左右通过组合按键esc+hjkl实现，符合vim使用习惯，适应起来也很快；

下载Karabiner在~/.config/karabiner/assets/complex_modifications目录下添加自己的配置文件

xxx.json

````
{
    "title": "xxx配置",
    "rules": [
        {
            "description": "Left Esc + hjkl to arrow keys Vim",
            "manipulators": [
                {
                    "from": {
                        "key_code": "h",
                        "modifiers": {
                            "mandatory": [
                                "right_shift"
                            ],
                            "optional": [
                                "any"
                            ]
                        }
                    },
                    "to": [
                        {
                            "key_code": "left_arrow"
                        }
                    ],
                    "type": "basic"
                },
                {
                    "from": {
                        "key_code": "j",
                        "modifiers": {
                            "mandatory": [
                                "right_shift"
                            ],
                            "optional": [
                                "any"
                            ]
                        }
                    },
                    "to": [
                        {
                            "key_code": "down_arrow"
                        }
                    ],
                    "type": "basic"
                },
                {
                    "from": {
                        "key_code": "k",
                        "modifiers": {
                            "mandatory": [
                                "right_shift"
                            ],
                            "optional": [
                                "any"
                            ]
                        }
                    },
                    "to": [
                        {
                            "key_code": "up_arrow"
                        }
                    ],
                    "type": "basic"
                },
                {
                    "from": {
                        "key_code": "l",
                        "modifiers": {
                            "mandatory": [
                                "right_shift"
                            ],
                            "optional": [
                                "any"
                            ]
                        }
                    },
                    "to": [
                        {
                            "key_code": "right_arrow"
                        }
                    ],
                    "type": "basic"
                }
            ]
        }
    ]
}
````

简单的配置下，通过左边shift+h j k l实现，测试下行不行；

然后在Karabiner中添加simple modifications

将 escape 映射到 right_shift上；

因为在配置中mandatory中写esccape发现无效，只好使用这个方案；

然后在Comples modifications中取消原配置，添加自己的配置；

....

我佛了。。。

当我在中文输错时，需要esc取消时，发现无效，esc已经变成right_shift了

然后改成tab映射到right_shift，当我切换程序时commond+tab时发现，tab也已经变成right_shift

然后我将left_option指向了right_shift，

但我发现可以保留tab按键，然后通过tab+hjkl来实现，就不需要改tab的健位效果了

但是实际tab+hjkl也无效，只能使用left_option，将right_shift改成left_option

__最终：__

````
{
    "title": "xxx配置",
    "rules": [
        {
            "description": "Left Option + hjkl to arrow keys Vim",
            "manipulators": [
                {
                    "from": {
                        "key_code": "h",
                        "modifiers": {
                            "mandatory": [
                                "left_option"
                            ],
                            "optional": [
                                "any"
                            ]
                        }
                    },
                    "to": [
                        {
                            "key_code": "left_arrow"
                        }
                    ],
                    "type": "basic"
                },
                {
                    "from": {
                        "key_code": "j",
                        "modifiers": {
                            "mandatory": [
                                "left_option"
                            ],
                            "optional": [
                                "any"
                            ]
                        }
                    },
                    "to": [
                        {
                            "key_code": "down_arrow"
                        }
                    ],
                    "type": "basic"
                },
                {
                    "from": {
                        "key_code": "k",
                        "modifiers": {
                            "mandatory": [
                                "left_option"
                            ],
                            "optional": [
                                "any"
                            ]
                        }
                    },
                    "to": [
                        {
                            "key_code": "up_arrow"
                        }
                    ],
                    "type": "basic"
                },
                {
                    "from": {
                        "key_code": "l",
                        "modifiers": {
                            "mandatory": [
                                "left_option"
                            ],
                            "optional": [
                                "any"
                            ]
                        }
                    },
                    "to": [
                        {
                            "key_code": "right_arrow"
                        }
                    ],
                    "type": "basic"
                }
            ]
        }
    ]
}
````



