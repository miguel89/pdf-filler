import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { WelcomeComponent } from './welcome/welcome.component';
import { FillerComponent } from './filler/filler.component';


const routes: Routes = [
  { path: '', component: WelcomeComponent },
  { path: 'document/:id', component: FillerComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {
}
