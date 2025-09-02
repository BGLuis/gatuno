import { Routes } from "@angular/router";
import { HomeComponent } from "./home/home.component";
import { TagsComponent } from "./tags/tags.component";

export const routes: Routes = [
    {
        path: '',
        pathMatch: 'full',
        redirectTo: 'home',
    },
    {
        path: 'home',
        component: HomeComponent,
    },
    {
        path: 'tags',
        component: TagsComponent,
    }
]
