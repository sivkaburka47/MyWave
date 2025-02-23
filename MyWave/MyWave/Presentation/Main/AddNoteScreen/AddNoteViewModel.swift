//
//  AddNoteViewModel.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import Foundation

protocol AddNoteViewModelProtocol {
    func completeFlow()
}

final class AddNoteViewModel: AddNoteViewModelProtocol {
    weak var coordinator: AddNoteCoordinator?
    
    func completeFlow() {
        coordinator?.completeFlow()
    }
}
