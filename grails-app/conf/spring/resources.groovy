import anotaciones.TrazabilidadAspecto
import auth.UserPasswordEncoderListener
// Place your Spring DSL code here
beans = {
    userPasswordEncoderListener(UserPasswordEncoderListener)
    trazabilidadAspecto(TrazabilidadAspecto)

}
