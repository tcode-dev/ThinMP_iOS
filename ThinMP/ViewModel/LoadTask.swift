//
//  LoadTask.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

/// ViewModel の読み込みのうち、最後に始めたものの結果だけを反映する
/// 読み込みは呼び出し元のタスクで走るので、View の .task が打ち切られると読み込みも打ち切られる
final class LoadTask {
    /// 読み込みを始めるたびに進める。終わったときに進んでいれば、後から始めた読み込みがある
    private var generation = 0

    /// fetch の結果を apply に渡す
    /// 呼び出し元が打ち切られたか、終わるまでに次の読み込みが始まっていたら、結果は捨てる
    func run<Value>(fetch: () async -> Value, apply: (Value) -> Void) async {
        generation += 1

        let current = generation
        let value = await fetch()

        if Task.isCancelled || current != generation {
            return
        }

        apply(value)
    }
}
