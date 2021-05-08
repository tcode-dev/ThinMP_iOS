//
//  ShortcutViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/08.
//

import RealmSwift
import MediaPlayer

class ShortcutViewModel: ViewModelProtocol {
    @Published var list: [ShortcutModel] = []

    func fetch() {
        let shortcutRepository = ShortcutRepository()
        let shortcutModels = shortcutRepository.findAll()
    }
}
