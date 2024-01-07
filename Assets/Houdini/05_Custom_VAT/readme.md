## 0.セットアップ
## 1.FBX Output
#### Path Attribute
#### Convert Unit
#### Export in ASCII Format
#### Packed Primitives

## 2.RBD to FBX
[Labs RBD to FBX](https://www.sidefx.com/ja/docs/houdini/nodes/out/labs--rbd_to_fbx-2.0.html)を使用するケース  
- これが一番手軽
- 'RBD'というノード名だが、パックプリミティブに汎用的に使える
- パックプリミティブの出力自体はFBX Outputにもともと備わっている機能
- 出力したアニメーションの設定はImport SettingsのAnimationから弄る
## 3.FBX Character Animation
[FBX Animation Output](https://www.sidefx.com/ja/docs/houdini/nodes/sop/kinefx--rop_fbxanimoutput.html)を使用するケース  
- RBD to FBXではアニメーションとメッシュが同じFBXで出力される  
- FBX Animation Outputを使用してメッシュFBXと階層構造が一致するボーンアニメーションを書き出すことでメッシュとアニメーションのファイルを分離できる
- ボーンアニメーションへの変換はSkelton SOP -> Transform Pieces SOP
## 4.FBX Character Output
[FBX Character Output](https://www.sidefx.com/ja/docs/houdini/nodes/sop/kinefx--rop_fbxcharacteroutput.html)を使用するケース
- 3の方法に加えてスキニングをする
- 2・3の方法だと各ピースごとに別々のサブメッシュにする必要があるが、対応するピースのウェイトが塗られた単一のスキンドメッシュにすることでレンダリング時の負荷を抑えられる
- スキニングはCapture Packed Geometry SOPを使用。`Pack Input`と`Unpack Output`を両方オンにする
- 単一のGameObjectになるのでUnity側での手動 or スクリプトでの各ピースのオンオフの切り替えができなくなる
## 5.Vertex Animation Texture
## 6.Original VAT
- 過去のVRChatではHoudni標準のVATを安定して動かすのが難しかったため、多かれ少なかれこれだった