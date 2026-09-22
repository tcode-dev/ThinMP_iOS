//
//  LoadTask.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

/// ViewModel の読み込みを 1 つだけ走らせる
/// 新しい読み込みを始めるときは直前のものを打ち切り、古い結果が新しい結果を上書きしないようにする
@MainActor
final class LoadTask {
    private var task: Task<Void, Never>?

    /// fetch の結果を apply に渡す。apply の前に打ち切られていたら結果は捨てる
    @discardableResult
    func run<Value>(fetch: @escaping @MainActor () async -> Value, apply: @escaping @MainActor (Value) -> Void) -> Task<Void, Never> {
        task?.cancel()

        let task = Task {
            let value = await fetch()

            if Task.isCancelled {
                return
            }

            apply(value)
        }

        self.task = task

        return task
    }
}
