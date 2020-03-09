import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
import tensorflow.keras as keras
import source_code.ann_python.ann_server as ann_server


def fct_model(tag_train, n_sol, n_inp, n_out):
    assert isinstance(tag_train, str), 'invalid size'
    assert isinstance(n_sol, int), 'invalid size'
    assert isinstance(n_inp, int), 'invalid size'
    assert isinstance(n_out, int), 'invalid size'

    model = keras.Sequential([
        keras.layers.Dense(64, input_dim=n_inp, activation='relu'),
        keras.layers.Dense(64, activation='relu'),
        keras.layers.Dense(64, activation='relu'),
        keras.layers.Dense(64, activation='relu'),
        keras.layers.Dense(64, activation='relu'),
        keras.layers.Dense(64, activation='relu'),
        keras.layers.Dense(64, activation='relu'),
        keras.layers.Dense(activation='linear', units=n_out),
    ])

    return model

def fct_train(tag_train, model, inp, out):
    assert isinstance(tag_train, str), 'invalid size'

    model.compile(loss='mse', optimizer=keras.optimizers.Adam(lr=0.001), metrics=['mae', 'mse'])
    history = model.fit(
        inp, out,
        batch_size=10,
        validation_split=0.2,
        epochs=100,
        shuffle=False,
        verbose=False,
        callbacks=[keras.callbacks.EarlyStopping(monitor='val_loss', patience=10)],
    )

    return (model, history)


if __name__ == "__main__":
    ann_server.run('localhost', 10000, 10, fct_model, fct_train)
