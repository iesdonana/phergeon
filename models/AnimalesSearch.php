<?php

namespace app\models;

use Yii;
use yii\base\Model;
use yii\data\ActiveDataProvider;

/**
 * AnimalesSearch represents the model behind the search form of `app\models\Animales`.
 */
class AnimalesSearch extends Animales
{
    public $distancia;

    public function rules()
    {
        return [
            [['id', 'id_usuario', 'tipo_animal', 'raza'], 'integer'],
            [['nombre', 'distancia', 'descripcion', 'edad', 'sexo'], 'safe'],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function scenarios()
    {
        // bypass scenarios() implementation in the parent class
        return Model::scenarios();
    }

    public function attributes()
    {
        return array_merge(parent::attributes(), ['distancia']);
    }



    /**
     * Creates data provider instance with search query applied.
     *
     * @param array $params
     *
     * @return ActiveDataProvider
     */
    public function search($params)
    {
        $query = Animales::find()->joinWith(['usuario', 'adopciones'])->where(['aprobado' => null])->orWhere(['aprobado' => false]);

        if (!Yii::$app->user->isGuest) {
            $x = Yii::$app->user->identity->posx;
            $y = Yii::$app->user->identity->posy;
            $dataProvider = new ActiveDataProvider([
                'query' => $query->andWhere(['!=', 'id_usuario', Yii::$app->user->identity->id]),
                'sort' => [
                       'defaultOrder' => [
                           'distancia' => SORT_ASC,
                       ],
                   ],
                'pagination' => [
                     'pageSize' => 18,
                 ],
               ]);
            $dataProvider->sort->attributes['distancia'] = [
                'asc' => ["abs(($x-posx) - ($y-posy))" => SORT_ASC],
                'desc' => ["abs(($x-posx) - ($y-posy))" => SORT_DESC],
            ];
        } else {
            $dataProvider = new ActiveDataProvider([
                'query' => $query->orderBy(['rol' => SORT_DESC]),
                // 'sort' => [
                //        'defaultOrder' => [
                //            'rol' => SORT_DESC,
                //        ],
                //    ],
                'pagination' => [
                    'pageSize' => 18,
                ],
            ]);
        }


        // add conditions that should always apply here






        $this->load($params);

        if (!$this->validate()) {
            // uncomment the following line if you do not want to return any records when validation fails
            // $query->where('0=1');
            return $dataProvider;
        }

        // grid filtering conditions
        $query->andFilterWhere([
            'id' => $this->id,
            'id_usuario' => $this->id_usuario,
            'tipo_animal' => $this->tipo_animal,
            'raza' => $this->raza,
            'distancia' => $this->distancia,
        ]);

        $query->andFilterWhere(['ilike', 'nombre', $this->nombre])
            ->andFilterWhere(['ilike', 'descripcion', $this->descripcion])
            ->andFilterWhere(['ilike', 'edad', $this->edad])
            ->andFilterWhere(['ilike', 'sexo', $this->sexo])
            ->andFilterWhere(['=', 'distancia', $this->distancia]);

        return $dataProvider;
    }
}
