//
//  ShortcutItemIdProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/05/09.
//

import MediaPlayer

protocol ShortcutItemIdProtocol {}

extension MPMediaEntityPersistentID: ShortcutItemIdProtocol {}
extension String: ShortcutItemIdProtocol {}
