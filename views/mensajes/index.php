<?php

use yii\helpers\Html;
use yii\grid\GridView;
use yii\bootstrap\Modal;
use yii\widgets\ListView;
use yii\bootstrap\Tabs;

/* @var $this yii\web\View */
/* @var $searchModel app\models\MensajesSearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Mis mensajes';
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="mensajes-index">

    <h1><?= Html::encode($this->title) ?></h1>
    <?php // echo $this->render('_search', ['model' => $searchModel]); ?>
    <?= Tabs::widget([
        'items' => [
            [
                'label' => 'Recibidos',
                'content' => ListView::widget([
                    'dataProvider' => $dataProvider,
                    'itemView' => 'mensaje',
                ]),
                'active' => true
            ],
            [
                'label' => 'Enviados',
                'content' => ListView::widget([
                    'dataProvider' => $dataProviderResp,
                    'itemView' => 'mensaje',
                ]),
                'active' => false,
            ],
        ],
    ]); ?>

</div>
